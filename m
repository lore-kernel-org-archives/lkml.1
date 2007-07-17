Return-Path: <linux-kernel-owner+w=401wt.eu-S964799AbXGQVkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799AbXGQVkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbXGQVj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:39:57 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53582
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbXGQVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:39:56 -0400
Date: Tue, 17 Jul 2007 14:27:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <871wf6g1q1.fsf@jbms.ath.cx>
Message-ID: <Pine.LNX.4.64.0707171423280.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
 <200707172217.01890.rjw@sisk.pl> <Pine.LNX.4.64.0707171328450.2467@asgard.lang.hm>
 <200707172323.51702.rjw@sisk.pl> <Pine.LNX.4.64.0707171414370.2467@asgard.lang.hm>
 <871wf6g1q1.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Jeremy Maitin-Shepard wrote:

> david@lang.hm writes:
>
> [snip]
>
>>> How do you guarantee that no tasks are scheduled when you get back to the
>>> hibernated kernel?
>
>> just don't schedule any userspace tasks. all you need to do is to execute the
>> ACPI sleep functions. you normally do that after stopping userspace
>> anyway.
>
> What does "stopping userspace" mean?  You already said it does not mean
> disabling interrupts.  But using the freezer is also not an option,
> since the avoidance of that is the main reason for the kexec approach in
> the first place.

just don't schedule any non-kernel threads.

remember that the normal shutdown/suspend procedure is (from another 
related thread)

> >>sys_reboot(LINUX_REBOOT_CMD_KEXEC)
> >>     kernel_kexec
> >>         kernel_restart_prepare
> >>             device_shutdown
> >>         machine_shutdown
> >>         machine_kexec

I'm just saying that instead of going back to the normal operation of the 
kernel you just go directly to the new shutdown routine instead.

> [snip]
>
>>> Well, not exactly.  If your battery runs out of power while you're suspended,
>>> but you have the image saved, it's still better to restore from the image,
>> even
>>> if something may not work correctly after the restore, than to risk a loss of
>>> data.
>
>> if things don't work correctly you are still risking the loss of data, the user
>> just doesn't know it.
>
> It should be possible on any system to do a hibernate followed by a
> shutdown (and then resume properly, without any problems).  Thus, for
> handling suspend to both, you resume as if the system had been shutdown,
> rather than resuming as if the system came from S4.

I agree with this, but according to Rafael if the "hibernated" image is 
assuming that the devices were put into low-power mode by ACPI and you 
boot up instead the system doesn't work right.

David Lang
