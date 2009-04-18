Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbZDRAZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbZDRAZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 20:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZDRAY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 20:24:58 -0400
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:46626 "HELO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752256AbZDRAY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 20:24:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Q: crypto/cipher.c
Date: Fri, 17 Apr 2009 20:24:07 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F9237@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Q: crypto/cipher.c
Thread-Index: Acm/u/yoZEJNCuwjQ2eL8cwMCSfrhw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Apr 2009 00:24:56.0176 (UTC) FILETIME=[19A4D700:01C9BFBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I have a question about the following code in crypto/cipher.c.

static void cipher_crypt_unaligned(void (*fn)(struct crypto_tfm *, u8 *,
					      const u8 *),
				   struct crypto_tfm *tfm,
				   u8 *dst, const u8 *src)
{
	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
	unsigned int size = crypto_tfm_alg_blocksize(tfm);
	u8 buffer[size + alignmask];
	u8 *tmp = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);

	memcpy(tmp, src, size);
	fn(tfm, tmp, tmp);
	memcpy(dst, tmp, size);
}

Doesn't the size of buffer need to be known at compile time for this
to actually work? Or do alignmask and size work out to be constants?

This appears to be buggy. But I may just be missing something...

Thanks,
Hartley
