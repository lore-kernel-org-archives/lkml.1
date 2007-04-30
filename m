Return-Path: <linux-kernel-owner+w=401wt.eu-S1946532AbXD3Rqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946532AbXD3Rqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946543AbXD3Rqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:46:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59205 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946532AbXD3Rqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:46:30 -0400
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Subject: 3d smoothness (was: Re: [patch] CFS scheduler, -v6)
Date: Mon, 30 Apr 2007 19:45:32 +0200
User-Agent: KMail/1.9.1
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
References: <1177809512.9756.10.camel@localhost> <20070429170908.GA31417@elte.hu> <20070429173902.GA4349@elte.hu>
In-Reply-To: <20070429173902.GA4349@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <200704301945.34082.lkml@metanurb.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007 19:39, Ingo Molnar wrote:
> hi Kasper,
>
> i found an aspect of CFS that could cause the kind of 'stuttering' you
> described in such detail. I'm wondering whether you could try the
> attached -v8-rc1 patch ontop of the -v7 CFS patch - does it improve the
> 'games FPS' situation in any way? Thanks in advance,
>
> 	Ingo

This patch makes things much worse, i'd categorize it as severe regression
compared to cfs 7. It makes the cursor in X stutter enormously, it even 
caused my entire X to lock up for a second, and events like keyboard input is 
totally wrecked, it lagged as i wrote in xchat. as for under load, it seems 
only worse..

Also if i just press a link in konqueror on some website, while it loads, the 
mouse is stuttering untill the page has loaded finished.

this seems weird because its such a relatively simple patch.

In the patchs defense, gtk seems to redraw faster (when, and only when 3d is 
NOT running)

i also discovered another thing about cfs 7 (without this patch), which is 
same behavior as old staircase/vanilla, but which SD actually fixes.

this is a wine case, where when it loads a level in world of warcraft, the 
audio skips. I believe this to be a problem in wine, however, in sd it 
actually does not skip. On the desktop however, the audio issues were totally 
fixed in v7..

mvh.
Kasper Sandberg
