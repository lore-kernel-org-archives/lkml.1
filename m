Return-Path: <linux-kernel-owner+w=401wt.eu-S1031389AbXDZSfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031389AbXDZSfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031411AbXDZSfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:35:53 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35548 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031389AbXDZSfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:35:52 -0400
Date: Thu, 26 Apr 2007 20:36:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426183602.GT3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com> <4630E9C8.5060000@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4630E9C8.5060000@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 02:04:56PM -0400, Jeff Garzik wrote:
> IMO, the closer you look, the more warts you find.  Before you starting 
> doing your work with kernel regressions, no one was really tracking it.  I 
> bet you have helped cut down on the regressions, but I have no good way to 
> quantify my gut feeling.
>
> Additional comments on developers and fixing regressions:
>
> * Sometimes seeing a long list, peoples' eyes glaze over.  Its just human 
> nature.  A long list also gives us no idea of scale, or severity.  I bet a 
> weekly "top 10 bugs and regressions" email would help focus developer 
> attention.

Top 10 ordered by what?

I always tried to put the most mysterious ones like "kwin dies silently" 
or "gammu no longer works" at the top of my lists hoping some developer 
might become interested in getting clues about them.

But when there were 15 outstanding suspend regressions, these were also 
important.

And how to order the rtl8139 netdriver regression reported one month ago 
against the snd_hda_intel regression reported one month ago?

Both are "only" drivers no longer working for some users, but there 
might be many more users for whom they don't work in 2.6.21 because the 
maintainers didn't bother to debug and fix them.

Ideally, maintainers should debug and fix regressions (and other bugs) 
without requiring weekly regression lists.

If bug reports and weekly reminders aren't enough, I don't think 
increasing the level of babysitting would make sense.

> * To be effective, lists, either long or top-10, must be pruned if you get 
> a sense that only one user is affected.  [With oopses and BUGs as a clear 
> exception,] many problems benefit from at least two users reporting a bug.

First of all we had several cases where one report by one user resulted 
in a serious bug being fixed. There might be only one -rc tester with a 
strange workload or some unusual hardware.

A bigger point is that "at least two users reporting a bug" assumes you 
always know whether two bug reports are for the same bug.
Some examples for problems:
- during early 2.6.21-rc, it was not unusual for users to run into
  three unrelated suspend related regressions on one computer
- during 2.6.20-rc, we had 4 similar looking reports, 3 for one
  regression, and the forth for a completely different regression
- during 2.6.21-rc, it turned out the following reports were caused
  by the same regression:
    kwin dies silently
    KDE problem if a sound is played while the display is suspended

> * It gets a bit tiresome to field the large number of driver bug reports 
> that eventually turn out to be related to broken interrupt handling 
> somehow.  I think we developers need to get better at showing users how to 
> isolate driver vs. PCI/ACPI/core bugs.  Maybe drivers need to start 
> introducing interrupt delivery tests into their probe code.  Overall, 
> broken interrupt handling manifests in several ways, most of which 
> initially appear symptomatic of a broken driver.

Regressions have the advantage of being able to compare with a 
known-good kernel.

If a driver works with 2.6.20 but doesn't work with 2.6.21-rc, ask the 
submitter for dmesg's from both and diff them. In my experience that 
usually gives a good indication whether or not it's an interrupt related 
ACPI/PCI issue.

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

