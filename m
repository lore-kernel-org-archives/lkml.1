Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYHLCE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYHLCE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 22:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYHLCES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 22:04:18 -0400
Received: from ozlabs.org ([203.10.76.45]:38155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbYHLCER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 22:04:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 1/3] add support for exporting symbols from .S files
Date: Tue, 12 Aug 2008 12:03:56 +1000
User-Agent: KMail/1.9.9
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, David Woodhouse <dwmw2@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linuxppc-dev@ozlabs.org
References: <200808111606.44103.arnd@arndb.de> <200808111618.08206.arnd@arndb.de>
In-Reply-To: <200808111618.08206.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121203.57182.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 00:18:07 Arnd Bergmann wrote:
> This makes it possible to export symbols from assembly files, instead
> of having to export them through an extra ksyms.c file.
>
> I found this nicer to implement using a gas macro than a cpp macro.
...
> +	.ifeq BITS_PER_LONG-32
> +	.align 3
> +\symtab:
> +	.long \sym
> +	.long \strtab
> +	.else
> +	.align 4

Good work!   Hmm, you can .balign BITS_PER_LONG/8 outside the ifeq.  
Unfortunately .long doesn't do the Right Thing on 64 bit, so getting rid of 
the if is harder.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
