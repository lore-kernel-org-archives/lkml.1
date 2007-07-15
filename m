Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbXGOWeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbXGOWeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbXGOWeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:34:04 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:56783
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbXGOWeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:34:03 -0400
Date: Sun, 15 Jul 2007 15:27:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
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
In-Reply-To: <200707160038.12943.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707151526080.25614@asgard.lang.hm>
References: <200707151433.34625.rjw@sisk.pl> <20070715125855.GA1737@gallifrey>
 <200707160038.12943.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:

> On Sunday, 15 July 2007 14:58, Dr. David Alan Gilbert wrote:
>> * Rafael J. Wysocki (rjw@sisk.pl) wrote:
>>
>>> (5) Hibernation should be transparent from the applications' point of view
>>>
>>>     Generally, applications should not notice that hibernation took place.
>>>     [Note that I don't regard all processes as applications and I think that
>>>     there may be processes which need to handle the hibernation in a special
>>>     way.]  Ideally, for example, if some audio is being played when a
>>>     hibernation starts, the audio player should be able to continue playing the
>>>     same audio after the restore from the point in which it has been
>>>     interrupted by the hibernation.  Also, the CPU affinities and similar
>>
>> That would be _so_ embarrassing in a library; I'd rather the audio
>> player had the opportunity to consider whether restarting was a good idea.
>>
>>> (6) State of devices from before hibernation should be restored, if possible
>>>
>>>     If possible, during a restore devices should be brought back to the same
>>>     state in which they were before the corresponding hibernation.  Of course
>>>     in some situations it might be impossible to do that (eg. the user
>>>     connected the hibernated system to a different IP subnet and then
>>>     restored), but as a general rule, we should do our best to restore the
>>>     state of devices, which is directly related to point (5) above.
>>
>> Or the user unplugs their flash drive after hibernation rather than before.
>>
>> Two things which I think would be nice to consider are:
>>    1) Encryption - I'd actually prefer if my luks device did not
>>        remember the key accross a hibernation; I want to be forced to
>>        reenter the phrase.  However I don't know what the best thing
>>        to do to partitions/applications using the luks device is.
>
> Encryption is possible with both the userland hibernation (aka uswsusp) and
> TuxOnIce (formerly known as suspend2).  Still, I don't consider it as a "must
> have" feature for a framework to be generally useful (many users don't use it
> anyway).

he's talking about the main system useing an encrypted device/partition, 
not the hibernate image being stored encrypted.

This would require the main system 'forget' the keys when it does the 
hinbernate and prompt for it again during the wake-up phase.

David Lang

