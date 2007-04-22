Return-Path: <linux-kernel-owner+w=401wt.eu-S1160999AbXDVX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160999AbXDVX0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161023AbXDVX0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:26:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1160999AbXDVX0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:26:44 -0400
Date: Sun, 22 Apr 2007 16:24:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Juliusz Chroboczek <jch@pps.jussieu.fr>
cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Davidsen <davidsen@tmr.com>,
       Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
In-Reply-To: <87647oblx5.fsf@pps.jussieu.fr>
Message-ID: <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org>
 <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org>
 <87647oblx5.fsf@pps.jussieu.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Apr 2007, Juliusz Chroboczek wrote:
> 
> Why not do it in the X server itself?  This will avoid controversial
> policy in the kernel, and have the added advantage of working with
> X servers that don't directly access hardware.

It's wrong *wherever* you do it.

The X server should not be re-niced. It was done in the past, and it was 
wrogn then (and caused problems - we had to tell people to undo it, 
because some distros had started doing it by default).

If you have a single client, the X server is *not* more important than the 
client, and indeed, renicing the X server causes bad patterns: just 
because the client sends a request does not mean that the X server should 
immediately be given the CPU as being "more important". 

In other words, the things that make it important that the X server _can_ 
get CPU time if needed are all totally different from the X server being 
"more important". The X server is more important only in the presense of 
multiple clients, not on its own! Needing to renice it is a hack for a bad 
scheduler, and shows that somebody doesn't understand the problem!

		Linus
