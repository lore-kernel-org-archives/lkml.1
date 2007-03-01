Return-Path: <linux-kernel-owner+w=401wt.eu-S965122AbXCAO44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122AbXCAO44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXCAO44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:56:56 -0500
Received: from mailin1.k-net.dk ([82.211.192.11]:2512 "EHLO mailin1.k-net.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965122AbXCAO44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:56:56 -0500
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
From: Kristian =?ISO-8859-1?Q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <200703010036.28166.dtor@insightbb.com>
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <1172622441.4587.14.camel@localhost.localdomain>
	 <200702281345.15098.rjw@sisk.pl>  <200703010036.28166.dtor@insightbb.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Mar 2007 15:55:52 +0100
Message-Id: <1172760952.21416.110.camel@miraculinux>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 00:36 -0500, Dmitry Torokhov wrote:
> On Wednesday 28 February 2007 07:45, Rafael J. Wysocki wrote:
> > 
> > > This gives:
> > > 
> > > (gdb) l *evdev_disconnect+0xb1
> > > 0xa81 is in evdev_disconnect (include/asm/processor.h:716).
> > > 711        However we don't do prefetches for pre XP Athlons currently
> > > 712        That should be fixed. */
> > > 713     #define ARCH_HAS_PREFETCH
> > > 714     static inline void prefetch(const void *x)
> > > 715     {
> > > 716             alternative_input(ASM_NOP4,
> > > 717                               "prefetchnta (%1)",
> > > 718                               X86_FEATURE_XMM,
> > > 719                               "r" (x));
> > > 720     }
> > 
> > Hm, interesting.  Looks like a pointer points to nowhere in
> > input_unregister_device(), but I don't know which one.  This may be
> > an evdev problem ...
> > 
> 
> Please try the patch below.

Hmmm. Is the diff against 2.6.20? All hunks except one fails when i try
it. If I pass "-F 3" to patch, then one more hunk succeeds. Am I doing
something wrong?

/Kristian

> -- 
> Dmitry
> 
> Input: use krefs for refcounting in input handlers
> 
> This should fix problems whith accessing memory already freed by
> another thread.

