Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbXGOT7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbXGOT7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXGOT7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:59:32 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34533
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbXGOT7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:59:31 -0400
Date: Sun, 15 Jul 2007 12:52:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: Al Boldi <a1426z@gawab.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707151220570.24011-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.64.0707151247140.25614@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707151220570.24011-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007, Alan Stern wrote:

>>> (7) On ACPI systems special platform-related actions have to be carried
>>> out at the right points, so that the platform works correctly after the
>>> restore
>>>
>>>     The ACPI specification requires us to invoke some global ACPI methods
>>>     during the hibernation and during the restore.  Moreover, the ordering
>>> of code related to these ACPI methods may not be arbitrary (eg. some of
>>> them have to be executed after devices are put into low power states
>>> etc.).
>>
>> This should be the responsibility of the kexec'd hibernating kernel.  Note
>> though in (6), the normal kernel takes care of preparing devices, then the
>> hibernating kernel dumps the image and either calls S4 or S3.  On resume
>> from S3 it can immediately switch over to the normal kernel, and from S4 the
>> known bootup would occur.
>
> Is it really that simple?  Somehow I doubt it.  In order for some
> devices to remain available for the kexec'd kernel to use, they cannot
> be suspended at the ACPI level.  So the kexec'd kernel will have to
> handle the ACPI requirements for those devices.  Likewise, it would
> have to handle the ACPI interactions which need to be done after all
> devices are prepared for the transition to S3 or S4.

so if there are two states for hardware

1. able to be detected and initialized with the standard boot routines

2. ACPI suspend mode, requireing ACPI specifics to wake up

is it possible to detect which is needed? cna you try the ACPI wakeup and 
if it doesn't work go to the standard boot routine (or vice-versa)?

>>> (8) Hibernation and restore should not be too slow
>>>
>>>     In my opinion, if more than one minute is needed to hibernate the
>>> system with the help of certain hibernation framework, then this framework
>>> is not very useful in practice.  It might be useful to perform some
>>> special tasks (eg. moving a server to another place without taking it
>>> down), but it is not very useful, for example, to notebook users.
>>
>> The latest hibernating kexec patches boot a kexec'd modular kernel with
>> initramfs into crashkernel=16M@16M in less than one second.  Switch-back is
>> almost instant.  Add to this the time required to either store or restore
>> the image, and it may be obvious that this approach isn't slower, but maybe
>> even faster than the current swsusp.
>
> Does that include the time required for probing PCI buses?  On my
> desktop system, PCI probing incurs a five-second timeout delay because
> of a bug in the BIOS's USB firmware.  Don't be so sure that kexec will
> always be lightning fast; it is always better to avoid unnecessary
> boots.

some drivers will have delays on some machines (especially when you 
consider hardware bugs that have to be worked around), but at the moment 
nothing is remotely close to the 'limit' of 60 seconds being talked about 
here.

although with some machines the mear trasnfer times for the data could 
cause noticable delays (if you have a server with 128G of ram it may take 
a while to get it to a drive)

David Lang
