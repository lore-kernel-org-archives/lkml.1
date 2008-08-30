Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYH3AX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYH3AX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 20:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYH3AXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 20:23:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbYH3AXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 20:23:48 -0400
Date: Fri, 29 Aug 2008 17:23:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dyn_array: using %pF instead of
 print_fn_descriptor_symbol
Message-Id: <20080829172304.bcfa5f9d.akpm@linux-foundation.org>
In-Reply-To: <86802c440808291634h1904b7ffmeb1697b2050e364b@mail.gmail.com>
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
	<20080829152053.92fa6fd4.akpm@linux-foundation.org>
	<86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com>
	<20080829155319.dc76b1c0.akpm@linux-foundation.org>
	<86802c440808291634h1904b7ffmeb1697b2050e364b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 16:34:26 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Fri, Aug 29, 2008 at 3:53 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >>       ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
> >>       if (!ptr)
> >>               panic("Can not alloc dyn_alloc\n");
> 
> like to give exact error message.

It's pointless.  panic() will do a dump_stack().

> >
> > Why duplicate the panic()?  Just call __alloc_bootmem().
> >
> >> #ifdef CONFIF_GENERIC_HARDIRQS
> >
> > That doesn't appear to have been very well tested?
> 
> ah!
> it should break sparc, m68k, and s390...
> 
> >
> > The code has a few coding-style glitches which checkpatch can detect.
> >
> 
> should only have 80 char length warning...
> 

sure.  The code looks rather miserable in an 80-col display.

there's also

WARNING: braces {} are not necessary for single statement blocks
#119: FILE: dyn_array.c:119:
+               if (da->init_work) {
+                       da->init_work(da);
+               }



and checkpatch should have detected the misplaced semicolon here:

+       for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {

but didn't.

		
