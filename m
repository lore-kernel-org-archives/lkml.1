Return-Path: <linux-kernel-owner+w=401wt.eu-S1764077AbXGQV2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764077AbXGQV2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbXGQV1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:27:54 -0400
Received: from sccrmhc13.comcast.net ([63.240.77.83]:48722 "EHLO
	sccrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbXGQV1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:27:53 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: david@lang.hm
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
	<200707172217.01890.rjw@sisk.pl>
	<Pine.LNX.4.64.0707171328450.2467@asgard.lang.hm>
	<200707172323.51702.rjw@sisk.pl>
	<Pine.LNX.4.64.0707171414370.2467@asgard.lang.hm>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 17 Jul 2007 17:27:34 -0400
In-Reply-To: <Pine.LNX.4.64.0707171414370.2467@asgard.lang.hm>
	(david@lang.hm's message of "Tue\, 17 Jul 2007 14\:17\:35 -0700 \(PDT\)")
Message-ID: <871wf6g1q1.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

[snip]

>> How do you guarantee that no tasks are scheduled when you get back to the
>> hibernated kernel?

> just don't schedule any userspace tasks. all you need to do is to execute the
> ACPI sleep functions. you normally do that after stopping userspace
> anyway.

What does "stopping userspace" mean?  You already said it does not mean
disabling interrupts.  But using the freezer is also not an option,
since the avoidance of that is the main reason for the kexec approach in
the first place.

[snip]

>> Well, not exactly.  If your battery runs out of power while you're suspended,
>> but you have the image saved, it's still better to restore from the image,
> even
>> if something may not work correctly after the restore, than to risk a loss of
>> data.

> if things don't work correctly you are still risking the loss of data, the user
> just doesn't know it.

It should be possible on any system to do a hibernate followed by a
shutdown (and then resume properly, without any problems).  Thus, for
handling suspend to both, you resume as if the system had been shutdown,
rather than resuming as if the system came from S4.

-- 
Jeremy Maitin-Shepard
