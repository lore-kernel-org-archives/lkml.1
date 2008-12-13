Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYLMWVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYLMWVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 17:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYLMWVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 17:21:36 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:56995 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYLMWVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 17:21:36 -0500
Date: Sat, 13 Dec 2008 23:22:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Andrew <nick@nick-andrew.net>, Matthew Wilcox <matthew@wil.cx>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in header files
Message-ID: <20081213222259.GB29080@uranus.ravnborg.org>
References: <20080503202718.GA9996@damson>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503202718.GA9996@damson>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 10:27:18PM +0200, Vegard Nossum wrote:
> Hi,
> 
> Here comes v2 of this tool. I've addressed most of your nitpicks and specific
> comments. Running 'make headerdep', will go through all headers (instead of
> source files as v1 did). Running with the --graph option will produce a
> dependency graph in the 'dot' language (GraphViz).
> 
> Note that I am not really making an attempt to include this in the kernel
> itself; I am submitting it in the hope that somebody will find it useful.
> 
> For Sam: Writing this in sparse is a waste of time. Sparse is good for parsing
> C code; this script only cares about a subset of the C _preprocessor_ parsing.
> Perl is good at this, and the script was finished in a couple of hours. Sparse
> is C and would require a bit more work, I'm sure.
> 
> The most useful tool, as suggested by several people (Matthew Wilcox,
> Sam Ravnborg), would be the one that detects unused headers and missing
> (implicit) includes. That is indeed a job for sparse. But not a job for me,
> or at least not yet :-)
> 
> So again, I have no expectations for this to go in the kernel -- but in my
> opinion a tool that could be used on the kernel headers with some advantage.

Hi Vegard.

Digging through my mailbox I found this patch of yours.
I tried to apply it and saw following output:
In file included from linux/mmzone.h,
                from linux/topology.h
                from linux/mmzone.h
                from linux/gfp.h
                from linux/slub_def.h
                from linux/slab.h
                from linux/percpu.h
                from asm-generic/irq_regs.h
include/asm-xtensa/irq_regs.h: warning: recursive header inclusion

But looking at the file (include/asm-xtensa/irq_regs.h) did
not help me understand where to look to fix it.

Can you pinpoint the culprint better so this is becoming useful?

I would also like to see this integrated with checkincludes.pl
as both script do some simple static checks of the header files.

Additional bonus if we can reuse this to do better check of
our exported headers.

	Sam
