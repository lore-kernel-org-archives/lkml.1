Return-Path: <linux-kernel-owner+w=401wt.eu-S936553AbXGTVjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936553AbXGTVjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936267AbXGTVio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:38:44 -0400
Received: from smtp.andrew.cmu.edu ([128.2.10.83]:44439 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbXGTVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:38:43 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: david@lang.hm, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707201722060.5241-100000@iolanthe.rowland.org>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 20 Jul 2007 17:37:35 -0400
In-Reply-To: <Pine.LNX.4.44L0.0707201722060.5241-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Fri\, 20 Jul 2007 17\:24\:30 -0400 \(EDT\)")
Message-ID: <877ioupxi8.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Fri, 20 Jul 2007 david@lang.hm wrote:
>> > Userspace can submit I/O requests.  Someone will have to audit every
>> > driver to make sure that such I/O requests don't cause a quiesced
>> > device to become active.  If the device is active, it will make the
>> > memory snapshot inconsistent with the on-device data.
>> 
>> assuming this is the suspend-from-ram after a kexec back from the 
>> write-to-disk kernel I don't think you are correct.
>> 
>> when doing a suspend-to-ram you get to a point where you just don't use 
>> any userspace.

> What do you mean?  How can you prevent user tasks from running?  That's 
> basically what the freezer does, and the whole point of this approach 
> is to eliminate the freezer.  Right?

Presumably no tasks at all would be scheduled.

>> from that point on you are just walking the device tree 
>> putting things into low-power mode. This is the point where we are talking 
>> about jumping to.

> Yes.  And putting things into low-power mode requires the ability to 
> run the scheduler, which means that user tasks can be scheduled, which 
> means that they can run.

Does it really (fundamentally) require scheduling tasks, particularly in
the case that the devices have already been put in the "quiesced" state?

-- 
Jeremy Maitin-Shepard
