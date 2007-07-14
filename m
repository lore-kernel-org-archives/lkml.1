Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbXGNHUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbXGNHUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXGNHUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:20:11 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52505
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbXGNHUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:20:10 -0400
Date: Sat, 14 Jul 2007 00:13:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: [PATCH 0/2] Kexec jump: The first step to kexec
 base hibernation
In-Reply-To: <Pine.LNX.4.44L0.0707131035150.4865-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0707140012290.25614@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707131035150.4865-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Alan Stern wrote:

> On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:
>
>>> I missed this discussion. is this idea to suspend, write to disk, but
>>> leave things in ram so that if you wakeup soon enough you have everything
>>> for ram, but if you don't and the battery dies you can restore from disk?
>>>
>>> if so I think it's a mistake to mix the two. it would be better to just
>>> suspend to ram, and wake up once in a while to check the battery state and
>>> when the battery gets low enough do the suspend to disk.
>>>
>>> otherwise you end up mixing the requirements of the two types of suspend,
>>> which is how things got so ugly in the first place.
>>
>> Not necessarily.  If we don't put devices into low power states before creating
>> the image, that should work just fine (quiesce devices, create the image or
>> kexec the new kernel, reprobe devices, save the image, suspend to RAM,
>> resume from RAM, continue - or restore from the image if power failed in the
>> meantime).  Still, for this purpose, both kernels need to be able to handle the
>> same set of devices.
>
> Why?
>
> Suppose the kexec kernel can't handle some device.  The normal kernel
> has already quiesced the device, so it will remain quiescent while the
> kexec kernel runs and throughout the suspend.  When the regular kernel
> regains control the device will be ready for use.  I don't see any
> problem.

remember that during the hibernation the box may be powered off.

but there's still no reason for the hibernate kernel to know how to access 
the USB TV Tuner for example.

David Lang
