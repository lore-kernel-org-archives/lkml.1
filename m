Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbZLPT0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbZLPT0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763151AbZLPT00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:26:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763143AbZLPT0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:26:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Wed, 16 Dec 2009 20:27:16 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912160311.05915.rjw@sisk.pl> <alpine.LFD.2.00.0912160737350.7454@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912160737350.7454@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912162027.16574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009, Linus Torvalds wrote:
> 
> On Wed, 16 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > The summarized data are below (the "big" numbers are averages and the +/-
> > numbers are standard deviations, all in milliseconds):
> > 
> > 			HP nx6325		MSI Wind U100
> > 
> > sync suspend		1482 (+/- 40)	1180 (+/- 24)
> > sync resume		2955 (+/- 2)	3597 (+/- 25)
> > 
> > async suspend		1553 (+/- 49)	1177 (+/- 32)
> > async resume		2692 (+/- 326)	3556  (+/- 33)
> > 
> > async+one-liner suspend	1600 (+/- 39)	1212 (+/- 41)
> > async+one-liner resume	2692 (+/- 324)	3579 (+/- 24)
> > 
> > async+extra suspend	1496 (+/- 37)	1217 (+/- 38)
> > async+extra resume	1859 (+/- 114)	1923 (+/- 35)
> > 
> > So, in my opinion, with the above set of "async" devices, it doesn't
> > make sense to do async suspend at all, because the sync suspend is actually
> > the fastest on both machines.
> 
> Hmm. I certainly agree - your numbers do not seem to support any async at 
> all.
> 
> However, I do note that for the "extra patch" makes a big difference at 
> resume time. That implies that the resume serializes on some slow device 
> that wasn't marked async - and starting the async ones early avoids that. 
> 
> But without the per-device timings, it's hard to even guess what device 
> that was.
> 
> But even that doesn't really help the suspend cases, only resume.
> 
> Do you have any sample timing output with devices listed?

I'm going to generate one shortly.

Rafael
