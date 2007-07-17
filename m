Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXGQEoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXGQEoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbXGQEog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:44:36 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46959
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXGQEof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:44:35 -0400
Date: Mon, 16 Jul 2007 21:33:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Al Boldi <a1426z@gawab.com>
cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Hibernation considerations
In-Reply-To: <200707161632.02334.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0707162129090.19248@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org>
 <200707160802.46567.a1426z@gawab.com> <Pine.LNX.4.64.0707152342140.19248@asgard.lang.hm>
 <200707161632.02334.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Al Boldi wrote:

> david@lang.hm wrote:
>> On Mon, 16 Jul 2007, Al Boldi wrote:
>>> david@lang.hm wrote:
>>>> suspend-to-RAM should not involve kexec, the only reason for doing the
>>>> kexec to to get a seperate userspace to use for suspend-to-disk
>>>> operations instead of trying to partially freeze the sustem and keep
>>>> useing it.
>>>
>>> Or you could do suspend-to-disk-and-RAM.  But in the above case, it was
>>> meant to test kexec compatibility with device suspend/resume calls.
>>
>> the point I am trying to make here is that there is no reason that the
>> kexec approach needs to do _any_ suspend/resume calls.
>
> When you go through ACPI, then that implies calling suspend/resume calls.

then don't go through ACPI

>> all that is needed is the ability of the new kernel to initialize the
>> devices it needs.
>
> We have to go through ACPI, for wakeup functions to succeed.  A simple
> power-off won't do.

the kexec switch being posted requires ACPI be disabled, so it's clearly 
possible to switch kernels and initialize devices without ACPI

>> suspend-to-disk-and-ram could be implemented as three
>> seperate steps
>>
>> 1. suspend-to-disk
>>
>> 2. resume-from-disk
>>
>> 3. suspend-to-ram
>>
>> followed by either
>>
>> 4. resume-from-ram
>>
>> or
>>
>> 4. battery dies and loptop powers off completely
>>
>> 5. power-on boot.
>>
>> 6. resume-from-disk
>>
>> all that you need to do is to make sure that the system doesn't run
>> anything that would affect permanent media or the outside world between
>> steps #2 and #3
>
> Exactly, which is why your scheme would break down on #3, and that's why you
> need to call S3 from within the kexec'd hibernation kernel after saving the
> hibernation image.

when a kexec is called, how does the kernel know what to execute? 
something needs to tell it what to do, and I think that something is 
either something in the kexec image, or it's something passed as a 
parameter to that image.

all that would be needed to do #3 safely is to have the kernel that you 
restarted on #2 do a suspend-to-ram before it does anything else.

David Lang
