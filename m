Return-Path: <linux-kernel-owner+w=401wt.eu-S935172AbXGTRcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935172AbXGTRcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764667AbXGTRbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:31:45 -0400
Received: from alnrmhc11.comcast.net ([206.18.177.51]:50926 "EHLO
	alnrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764624AbXGTRbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:31:44 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Milton Miller <miltonm@bga.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
	<200707192228.05136.rjw@sisk.pl>
	<Pine.LNX.4.64.0707191542430.28721@asgard.lang.hm>
	<200707201317.58025.rjw@sisk.pl>
	<f29402c6050f9c3ff5d83a59cea2de58@bga.com>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 20 Jul 2007 13:31:41 -0400
In-Reply-To: <f29402c6050f9c3ff5d83a59cea2de58@bga.com> (Milton Miller's
	message of "Fri\, 20 Jul 2007 11\:56\:43 -0500")
Message-ID: <87myxroubm.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milton Miller <miltonm@bga.com> writes:

[snip]

>>>> (7) how to avoid corrupting filesystems mounted by the hibernated kernel
>>> 
>>> I didn't realize this was a discussion item. I thought the options were
>>> clear, for some filesystem types you can mount them read-only, but for
>>> ext3 (and possilby other less common ones) you just plain cannot touch
>>> them.
>> 
>> That's correct.  And since you cannot thouch ext3, you need either to assume
>> that you won't touch filesystems at all, or to have a code to recognize the
>> filesystem you're dealing with.

> Or add a small bit of infrastructure that errors writes at make_request if you
> don't have a magic "i am a direct block device write from userspace" flag on the
> bio.

I still don't understand why there is this fixation on accessing dirty
filesystems in use by the hibernated system.  Even if you avoid
corrupting the filesystem by avoiding writing to the block device, there
isn't any real guarantee about the state of the data, except for a
filesystem that specifically makes guarantees about such data (and I
don't believe any of the existing ones do).

It isn't necessary to be able to access such filesystems: everything can
be done from an initramfs/initrd.

[snip]

-- 
Jeremy Maitin-Shepard
