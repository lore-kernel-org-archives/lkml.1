Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXJUBi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXJUBi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXJUBiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:38:02 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbXJUBiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:38:00 -0400
Date: Sat, 20 Oct 2007 14:45:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
In-Reply-To: <200710202244.00671.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0710201430510.10525@woody.linux-foundation.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
 <20071020191534.GA8774@uranus.ravnborg.org>
 <alpine.LFD.0.999.0710201232100.10525@woody.linux-foundation.org>
 <200710202244.00671.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Oct 2007, Andi Kleen wrote:
> 
> It's not only next. The latest release (1.5.3.4) has this problem.

Yes. It's ok in the master branch, but due to unlucky timing with noticing 
this bug, and Junio being away, no releases got cut with the fix. 

In general, the kernel people haven't done many renames (I think it's 
something we have avoided historically, just because it makes diffs almost 
totally unreadable - even while git supports "rename diffs", they are 
turned off by default just to be compatible with people who use quilt and 
raw patch).

So we've basically had a "perfect storm" of (a) Junio being away, (b) a 
really stupid bug that got introduced recently, (c) a few broken 
heuristics that had little testing because the kernel almost never does 
renames anyway and (d) suddenly lots of renames in the kernel all at once.

(It's not even just the x86 stuff - we had all the watchdog drivers being 
moved around too, so we probably had almost as many renames the last two 
weeks than we've had in the two years preceding it ;)

[ Just for fun, I checked. Yup. In the last two weeks, git finds 1120 
  copies and renames. Over the last two and a half years (ie the whole git 
  timeframe), we have 2136 of them. So we really have done more renames in 
  the last two weeks than we have over the whole rest of the git history,
  and it wasn't just my imagination ]

			Linus
