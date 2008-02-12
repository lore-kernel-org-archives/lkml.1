Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYBLAh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYBLAh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYBLAht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:37:49 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:50047 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYBLAhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:37:48 -0500
Date: Mon, 11 Feb 2008 19:36:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>
Subject: Re: [10/19] ftrace: add basic support for gcc profiler instrumentation
In-Reply-To: <Pine.LNX.4.64.0802101315390.7176@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.58.0802111931420.6780@gandalf.stny.rr.com>
References: <20080210072035.GK4100@elte.hu> <Pine.LNX.4.64.0802101315390.7176@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 10 Feb 2008, Jan Engelhardt wrote:

>
> On Feb 10 2008 08:20, Ingo Molnar wrote:
> >--- linux.orig/Makefile
> >+++ linux/Makefile
> >@@ -509,6 +509,9 @@ endif
> >
> > include $(srctree)/arch/$(SRCARCH)/Makefile
> >
> >+ifdef CONFIG_FTRACE
> >+KBUILD_CFLAGS	+= -pg
> >+endif
> > ifdef CONFIG_FRAME_POINTER
> > KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
> > else
>
> You should use -fno-omit-frame-pointer when building with -pg; As far
> as I can remember from using gprof in the past (in userspace, I might
> add), the output does not make much sense without frame boundaries.
>

It is, but is hidden in the Kconfig. I moved it to Kconfig as it was
recommended to me because it is cleaner to do it there.

Two patches later:

+config FTRACE
+       bool "Kernel Function Tracer"
+       depends on DEBUG_KERNEL && HAVE_FTRACE
+       select FRAME_POINTER


-- Steve

