Return-Path: <linux-kernel-owner+w=401wt.eu-S1764082AbXGPAFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764082AbXGPAFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbXGPAFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:05:32 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39153
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbXGPAFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:05:30 -0400
Date: Sun, 15 Jul 2007 16:58:54 -0700 (PDT)
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
In-Reply-To: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.64.0707151654420.25614@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007, Alan Stern wrote:

> On Sun, 15 Jul 2007, Al Boldi wrote:
>
>> Alan Stern wrote:
>>> On Sun, 15 Jul 2007, Al Boldi wrote:
>
>>>> This should be the responsibility of the kexec'd hibernating kernel.
>>>> Note though in (6), the normal kernel takes care of preparing devices,
>>>> then the hibernating kernel dumps the image and either calls S4 or S3.
>>>> On resume from S3 it can immediately switch over to the normal kernel,
>>>> and from S4 the known bootup would occur.
>>>
>>> Is it really that simple?  Somehow I doubt it.  In order for some
>>> devices to remain available for the kexec'd kernel to use, they cannot
>>> be suspended at the ACPI level.  So the kexec'd kernel will have to
>>> handle the ACPI requirements for those devices.  Likewise, it would
>>> have to handle the ACPI interactions which need to be done after all
>>> devices are prepared for the transition to S3 or S4.
>>
>> Ok, after applying the latest kexec patches, I was able to use the kexec'd
>> kernel to suspend to ram and resume to the normal kernel, while working
>> under a full-blown X session.  It went without a hitch.  All that is needed
>> now are the dump/restore hibernation-image routines.
>
> That's exactly my point.  While doing suspend-to-RAM from a kexec'd
> kernel may be simple, saving the hibernation image will add
> complications.

suspend-to-RAM should not involve kexec, the only reason for doing the 
kexec to to get a seperate userspace to use for suspend-to-disk operations 
instead of trying to partially freeze the sustem and keep useing it.

David Lang
