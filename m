Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbXKHOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbXKHOBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbXKHOBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:01:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbXKHOBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:01:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071108041314.GG26163@stusta.de>
References: <20071108041314.GG26163@stusta.de> <20071107174323.31820.65054.stgit@warthog.procyon.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel [try #3]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 08 Nov 2007 14:00:08 +0000
Message-ID: <21923.1194530408@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> The patch to include/asm-generic/Kbuild.asm doesn't seem to be required.

It is.  asm/a.out.h does not exist for MN10300, therefore the export process
breaks unless it is told not to export this header.  The alternative is to
move this line into each arch's individual header Kbuild file.

Whatever, I've moved this to the AOUT suppression patch as that's where it
logically belongs.

> +#elif defined(__mn10300__)
> 
> Please use a CONFIG_ variable in such cases.

Done.  However, I suspect these should be moved into an arch header file
somewhere.

> The parts outside arch/mn10300/ and include/asm-mn10300/ (except for the 
> trivial "&& {,!}MN10300" Kconfig changes) should go separately through 
> the maintainers or get ACKs from the maintainers, even more since they 
> also contain cleanups like
> 
> -               .regions = {ERASEINFO(0x01000,64),
> +               .regions        = {
> +                       ERASEINFO(0x01000,64),
>                 }

I've ditched the extraneous cleanups.  The jedec file needs a lot of cleanup
work anyway as it's got a lot of lines that begin with a space and a tab, but
that's outside of the scope of these patches.

I've split the addition of the jedec chip type, the fix for the net2280 driver
and the allocation of UART port types into separate patches.  These can go in
advance of the main patch.

I've split the remaining MTD changes into their own patch that goes after the
main patch.

> +extern void __kprobes arch_remove_kprobe(struct kprobe *p);

I've moved that into asm-mn10300/kprobes.h.

> > A suitable toolchain can be downloaded from:
> > 
> > 	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
> >...
> 
> What is the status of support in upstream GNU binutils and GNU gcc?

Upstream and been there for years I believe.

David
