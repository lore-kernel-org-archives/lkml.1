Return-Path: <linux-kernel-owner+w=401wt.eu-S935181AbXGQUvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935181AbXGQUvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759372AbXGQUtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:49:06 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39584
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760846AbXGQUtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:49:05 -0400
Date: Tue, 17 Jul 2007 13:37:08 -0700 (PDT)
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
In-Reply-To: <87odiag45q.fsf@jbms.ath.cx>
Message-ID: <Pine.LNX.4.64.0707171335180.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
 <200707172217.01890.rjw@sisk.pl> <87odiag45q.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Jeremy Maitin-Shepard wrote:

> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
> [snip]
>
>>> Rafael, for those of us who aren't thoroughly familiar with all the ins
>>> and outs of the ACPI spec, could you please summarize a list of the
>>> ACPI calls needed in the second and third cases above?  Indicate which
>>> ones need to be done from within the original kernel and which should
>>> be done from within a kexec'd hibernation kernel.
>
>> Sure.
>
>> In the third case (ie. transition to S4) we are supposed to do the following:
>
>> (1) Upon entering the sleep state, which IMO can be done _after_ the image
>>     has been saved:
>
> I assume you mean "in order to enter the sleep state", rather than "upon
> entering the sleep state".  I still don't understand what you mean by
> "which IMO can be done _after_ the image has been saved"; as far as I
> understand, the last step of this process, "make the platform enter S4",
> is almost like a shutdown as far as the kernel is concerned (except for
> the tiny detail of having to call those special ACPI methods on resume);
> consequently, it would seem that nothing can be done after that step.
>
>>   * figure out which devices can wake up
>>   * put devices into low power states (wake-up devices are placed in the Dx
>>     states compatible with the wake capability, the others are powered off)

this can't be done by the image-saving kernel if that kernel doesn't know 
about the device.

David Lang
