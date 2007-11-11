Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXKKCOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXKKCOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 21:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXKKCOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 21:14:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbXKKCOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 21:14:38 -0500
Date: Sat, 10 Nov 2007 18:14:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
 !CONFIG_BINFMT_AOUT [try #5]
Message-Id: <20071110181416.31dc2614.akpm@linux-foundation.org>
In-Reply-To: <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
References: <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2007 15:34:37 +0000 David Howells <dhowells@redhat.com> wrote:

> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -1,3 +1,4 @@
> +# -*- makefile -*-

what's that?

>  header-y += byteorder/
>  header-y += dvb/
>  header-y += hdlc/
> @@ -17,7 +18,9 @@ header-y += usb/
>  
>  header-y += affs_hardblocks.h
>  header-y += aio_abi.h
> +ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
>  header-y += a.out.h
> +endif

Note that because of unexport-asm-pageh.patch I turned the above hunk into

ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
unifdef-y += a.out.h
endif

which seems logical to me.  We'll see how it tests out.
