Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYCLOto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYCLOto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYCLOtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:49:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYCLOte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:49:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080218140704.4e0d6dba@crazy>
References: <20080218140704.4e0d6dba@crazy> <200802152010.m1FKANcT021529@imap1.linux-foundation.org> <20080215203103.GA22118@flint.arm.linux.org.uk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: dhowells@redhat.com, Russell King <rmk@arm.linux.org.uk>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, hpa@zytor.com,
       ink@jurassic.park.msu.ru, kkojima@rr.iij4u.or.jp, lethal@linux-sh.org,
       mingo@elte.hu, mpm@selenic.com, rc@rc0.org.uk, rth@twiddle.net,
       starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de,
       ysato@users.sourceforge.jp, Byron Bradley <byron.bbradley@gmail.com>,
       linux-kernel@vger.kernel.org, michael@free-electrons.com
Subject: Re: + inflate-refactor-inflate-malloc-code.patch added to -mm tree
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 12 Mar 2008 14:47:31 +0000
Message-ID: <13565.1205333251@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> inflate: refactor inflate malloc code
> 
> Inflate requires some dynamic memory allocation very early in the boot
> process and this is provided with a set of four functions:
> malloc/free/gzip_mark/gzip_release.
> 
> The old inflate code used a mark/release strategy rather than
> implement free. This new version instead keeps a count on the number
> of outstanding allocations and when it hits zero, it resets the malloc
> arena.
> 
> This allows removing all the mark and release implementations and
> unifying all the malloc/free implementations.
> 
> The architecture-dependent code must define two addresses:
>  - free_mem_ptr, the address of the beginning of the area in which
>    allocations should be made
>  - free_mem_end_ptr, the address of the end of the area in which
>    allocations should be made. If set to 0, then no check is made on
>    the number of allocations, it just grows as much as needed
> 
> The architecture-dependent code can also provide an arch_decomp_wdog()
> function call. This function will be called several times during the
> decompression process, and allow to notify the watchdog that the
> system is still running. If an architecture provides such a call, then
> it must define ARCH_HAS_DECOMP_WDOG so that the generic inflate code
> calls arch_decomp_wdog().
> 
> Work initially done by Matt Mackall <mpm@selenic.com>, updated to a
> recent version of the kernel by me.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Works on MN10300.

Acked-by: David Howells <dhowells@redhat.com>
