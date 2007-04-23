Return-Path: <linux-kernel-owner+w=401wt.eu-S1030354AbXDWBeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354AbXDWBeo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 21:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030433AbXDWBeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 21:34:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:54770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030354AbXDWBeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 21:34:44 -0400
Date: Mon, 23 Apr 2007 03:34:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Juliusz Chroboczek <jch@pps.jussieu.fr>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070423013429.GB25162@wotan.suse.de>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 04:24:47PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 22 Apr 2007, Juliusz Chroboczek wrote:
> > 
> > Why not do it in the X server itself?  This will avoid controversial
> > policy in the kernel, and have the added advantage of working with
> > X servers that don't directly access hardware.
> 
> It's wrong *wherever* you do it.
> 
> The X server should not be re-niced. It was done in the past, and it was 
> wrogn then (and caused problems - we had to tell people to undo it, 
> because some distros had started doing it by default).

The 2.6 scheduler can get very bad latency problems with the X server
reniced.


> If you have a single client, the X server is *not* more important than the 
> client, and indeed, renicing the X server causes bad patterns: just 
> because the client sends a request does not mean that the X server should 
> immediately be given the CPU as being "more important". 

If the client is doing some processing, and the user moves the mouse, it
feels much more interactive if the pointer moves rather than waits for
the client to finish processing.
