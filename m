Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbXD2Bei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbXD2Bei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 21:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXD2Bei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 21:34:38 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:40430 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXD2Beh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 21:34:37 -0400
Message-ID: <4633F62A.2050801@kernel.org>
Date: Sat, 28 Apr 2007 18:34:34 -0700
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: David Lang <david.lang@digitalinsight.com>,
       Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: <4630DF19.3060805@kernel.org> <alpine.LFD.0.98.0704261036120.9964@woody.linux-foundation.org> <46339E0C.4070109@tmr.com> <Pine.LNX.4.63.0704281214380.11638@qynat.qvtvafvgr.pbz> <20070429010428.GA8117@srcf.ucam.org>
In-Reply-To: <20070429010428.GA8117@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Sat, Apr 28, 2007 at 12:15:50PM -0700, David Lang wrote:
>> with dynaticks now in the kernel it may even be possible to have the idle 
>> process decide that the next event is far enough away that it should 
>> suspend-to-ram until that point.
> 
> This would be ideal (and it's broadly what the OLPC guys are aiming for, 
> I think), but on most platforms you're looking at at least a second or 
> so to resume. As far as I know, we're still looking at ~60 ticks a 
> second at best for an average desktop, so that's not going to be a win.

As long as the system has a clear idea of how long it will take to resume, it
can schedule a wakeup for a reasonable amount of time before that.  Ideally, a
completely unused system might not need a tick for several seconds.  However,
I agree that it doesn't make sense to add such functionality to the kernel
until someone can show a system that can actually wait that long between
ticks.

- Josh Triplett
