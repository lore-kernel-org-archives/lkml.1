Return-Path: <linux-kernel-owner+w=401wt.eu-S936019AbXGQVLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936019AbXGQVLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbXGQVLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:11:47 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:47085
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbXGQVLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:11:46 -0400
Date: Tue, 17 Jul 2007 14:04:13 -0700 (PDT)
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
In-Reply-To: <87fy3mg39r.fsf@jbms.ath.cx>
Message-ID: <Pine.LNX.4.64.0707171354240.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
 <200707172217.01890.rjw@sisk.pl> <Pine.LNX.4.64.0707171328450.2467@asgard.lang.hm>
 <87fy3mg39r.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Jeremy Maitin-Shepard wrote:

> david@lang.hm writes:
>
> [snip]
>
>> this is where we disagree.
>
>> why not? if all that the hibernated kernel does is to suspend-to-ram and makes
>> no changes to disks or TCP connections anything that it does do would be lost if
>> power were to fail and you instead did a restore from disk.
>
> It would be okay to switch the "hibernated" kernel in order to
> e.g. initiate a suspend to ram provided that everything is done
> atomically with interrupts off, for instance.  It is not clear, though,
> that it is possible to suspend to ram atomically like that.

why would it neeed to be with interrupts off?

I am arguing that it wouldn't matter if the "hibernated" kernel changed 
every bit of ram, as long as it didn't change anything that would be 
visable when the ram is overwritten by the saved image.

> There is also the question of what state the devices will be in when
> switching back from the "save image" kernel to the "hibernated" kernel.

yes, this is a key factor.

if the saved image assumes that the hardware is in some ACPI mode instead 
of re-initializeing the hardware then the suspend-to-ram operation could 
leave them in a different mode.

but if the saved image doesn't make assumptions about the hardware modes 
and initializes the hardware then it shouldn't matter.

David Lang
