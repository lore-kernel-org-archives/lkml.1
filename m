Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZCDLZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZCDLZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZCDLZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:25:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39396 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZCDLZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:25:13 -0500
Date: Wed, 4 Mar 2009 12:24:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mike Galbraith <efault@gmx.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large amount of scsi-sgpool objects
Message-ID: <20090304112455.GB14593@elte.hu>
References: <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de> <20090303234834.GA13389@elte.hu> <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net> <49AE32B5.9040603@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49AE32B5.9040603@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Mike Galbraith wrote:
> > On Wed, 2009-03-04 at 07:39 +0100, Stefan Richter wrote:
> >> Ingo Molnar wrote:
> >>> Yeah, these commits are in none of the topic branches that are 
> >>> the git base of development, they are all already in a separate 
> >>> branch named "tip:out-of-tree".
> >> So people should remember to retry without out-of-tree before reporting
> >> problems == remember to report against the development base.
> > 
> > I'll bite, how does a gut-fu white belt accomplish that?
> 
> How to do it is currently not quite obvious
>   - for linux-2.6-x86.git users because the master branch contains
>     out-of-tree.¹  Or maybe nobody should use the master branch,
>     I don't know.
>   - Ditto for linux-2.6.tip.git.²
> It was also impossible for users of the -rt patchset because the faulty
> patch was obviously included in a base patch in the -rt patch series.³

Dont be silly. Have you never seen a faulty v1 fix patch in -mm 
or any of the other dozens of generic trees, replaced by a 
better working v2 patch in the next release?

FYI, we still have not tracked down the SCSI bug. Latest 
tip:master is able to boot and work on the affected systems, 
while the upstream kernel does not even boot because the fix (or 
the revert, should the fix be deemed unwanted) is stuck in the 
SCSI tree.

But even with all known SCSI fixes applied there's still a crash 
in the SCSI code that Thomas can trigger - reproduced on 
mainline as well.

Instead of spreading advice in this thread about how to run a 
high-volume generic tree [which you've never done before] you 
could also have used your time to look at the crashes that were 
posted, and you could have helped us fix the bug ;-)

	Ingo
