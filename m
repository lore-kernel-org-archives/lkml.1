Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZDTSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZDTSlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZDTSlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:41:46 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:43155 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZDTSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:41:45 -0400
Message-ID: <49ECC1DF.3040401@grupopie.com>
Date: Mon, 20 Apr 2009 19:41:35 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Q: crypto/cipher.c
References: <BD79186B4FD85F4B8E60E381CAEE1909015F9237@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F9237@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> Hello all,

Hi,

> I have a question about the following code in crypto/cipher.c.
> 
> static void cipher_crypt_unaligned(void (*fn)(struct crypto_tfm *, u8 *,
> 					      const u8 *),
> 				   struct crypto_tfm *tfm,
> 				   u8 *dst, const u8 *src)
> {
> 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
> 	unsigned int size = crypto_tfm_alg_blocksize(tfm);
> 	u8 buffer[size + alignmask];
> 	u8 *tmp = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
> 
> 	memcpy(tmp, src, size);
> 	fn(tfm, tmp, tmp);
> 	memcpy(dst, tmp, size);
> }
> 
> Doesn't the size of buffer need to be known at compile time for this
> to actually work? Or do alignmask and size work out to be constants?
> 
> This appears to be buggy. But I may just be missing something...

It's a GCC extension:

http://gcc.gnu.org/onlinedocs/gcc/Variable-Length.html

-- 
Paulo Marques - www.grupopie.com

"All generalizations are false."
