Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbXGQUui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbXGQUui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936336AbXGQUqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:46:07 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:33441
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934825AbXGQUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:46:05 -0400
Date: Tue, 17 Jul 2007 13:34:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <200707172217.01890.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707171328450.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
 <200707172217.01890.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:

> On Tuesday, 17 July 2007 20:32, Alan Stern wrote:
>
>> I'm still not entirely clear on how "suspend-to-both" ought to be
>> handled.  Presumably it will start off as a normal hibernation.  But
>> instead of shutting down, wouldn't the kexec'd kernel return to the
>> original kernel?
>
> No, I think the image-saving kernel should suspend.  Then, on resume the
> platform will go back to it and it will jump back to the hibernated kernel.
>
>> After all, the original kernel knows about all the devices and can put them
>> into a low-power state, while the kexec'd kernel might not have sufficient
>> information.
>
> That's correct, but ...
>
>> But what about the freezer?  The original reason for using kexec was to
>> avoid the need for the freezer.  With no freezer, while the original
>> kernel is busy powering down its devices, user tasks will be free to
>> carry out I/O -- which will make the memory snapshot inconsistent with
>> the on-disk data structures.
>
> ... we can't return to the hibernated kernel unless we are going to cancel the
> hibernation.

this is where we disagree.

why not? if all that the hibernated kernel does is to suspend-to-ram and 
makes no changes to disks or TCP connections anything that it does do 
would be lost if power were to fail and you instead did a restore from 
disk.

there is only a problem if something takes place that would prevent the 
restore-from-disk from working. if this is done in a non-ACPI way that 
will work across a power cycle you don't have to worry about the hardware 
state not matching anyway.

> That's why I think that for the suspend-to-both the image-saving kernel will
> need to support the same set of devices as the hibernated kernel.

suspend-to-both doesn't really make sense if the suspend-to-disk portion 
is useing the ACPI S4 mode.

if you don't run out of power you will restore-from-ram

if you do run out of power the restore-from-disk won't work either becouse 
devices are not in the right ACPI states.

David Lang
