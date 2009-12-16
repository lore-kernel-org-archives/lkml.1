Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZLPPsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZLPPsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756294AbZLPPsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:48:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064AbZLPPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:48:37 -0500
Date: Wed, 16 Dec 2009 07:47:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912160311.05915.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912160737350.7454@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912151203.22916.rjw@sisk.pl> <alpine.LFD.2.00.0912150722310.14385@localhost.localdomain> <200912160311.05915.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Dec 2009, Rafael J. Wysocki wrote:
> 
> The summarized data are below (the "big" numbers are averages and the +/-
> numbers are standard deviations, all in milliseconds):
> 
> 			HP nx6325		MSI Wind U100
> 
> sync suspend		1482 (+/- 40)	1180 (+/- 24)
> sync resume		2955 (+/- 2)	3597 (+/- 25)
> 
> async suspend		1553 (+/- 49)	1177 (+/- 32)
> async resume		2692 (+/- 326)	3556  (+/- 33)
> 
> async+one-liner suspend	1600 (+/- 39)	1212 (+/- 41)
> async+one-liner resume	2692 (+/- 324)	3579 (+/- 24)
> 
> async+extra suspend	1496 (+/- 37)	1217 (+/- 38)
> async+extra resume	1859 (+/- 114)	1923 (+/- 35)
> 
> So, in my opinion, with the above set of "async" devices, it doesn't
> make sense to do async suspend at all, because the sync suspend is actually
> the fastest on both machines.

Hmm. I certainly agree - your numbers do not seem to support any async at 
all.

However, I do note that for the "extra patch" makes a big difference at 
resume time. That implies that the resume serializes on some slow device 
that wasn't marked async - and starting the async ones early avoids that. 

But without the per-device timings, it's hard to even guess what device 
that was.

But even that doesn't really help the suspend cases, only resume.

Do you have any sample timing output with devices listed?

			Linus
