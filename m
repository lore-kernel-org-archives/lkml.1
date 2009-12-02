Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZLBKzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZLBKzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZLBKzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:55:18 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:47012 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZLBKzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:55:16 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200912011328.15551.rjw@sisk.pl>
	<877ht68u4h.fsf@tac.ki.iif.hu> <200912012232.50951.rjw@sisk.pl>
	<87638qw2zy.fsf@tac.ki.iif.hu>
Date: Wed, 02 Dec 2009 11:55:07 +0100
In-Reply-To: <87638qw2zy.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Wed,
	02 Dec 2009 02:58:41 +0100")
Message-ID: <87skbtve5w.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
>> On Tuesday 01 December 2009, Ferenc Wagner wrote:
>>
>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>> 
>>>> On Tuesday 01 December 2009, Ferenc Wagner wrote:
>>>>
>>>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>>>
>>>>>> In addition to that, you can run multiple hibernation/resume cycles in
>>>>>> a tight loop using the RTC wakealarm.
>>>>> 
>>>>> I'll do so, as soon as I find a way to automatically supply the dm-crypt
>>>>> passphrase... or even better, learn to hibernate to ramdisk from the
>>>>> initramfs. :)
>>>>
>>>> Well, you don't need to use swap encryption for _testing_. :-)
>>> 
>>> I use partition encryption, everything except for /boot is encrypted.
>>
>> If /boot is big enough, you could use a swap file in /boot for the testing.
>
> Ramdisk worked good.  Maybe too good, because I left the machine doing
> s2disks while I was having dinner, and it achieved some 120 suspends
> without a freeze.  Only the e100 and the mii modules were loaded.
>
> After some script munging I got the machine automatically boot with an
> alternate passphrase, so in vivo testing is possible now.  I mean,
> tomorrow.

After almost 100 hibernate/resume cycles, I have to say that this issue
can't be reproduced by suspending in a tight loop.  I tried that while
flood pinging my gateway and also with no network activity.  The rc8
e100 module was loaded all the time.

> Btw. s2disk has a strange effect of simulating enters during suspend.
> [...]
> Can you also see this?

It can't be seen from the "sleep 1; s2disk" command, so it's probably an
artifact from X, when s2disk starts before Enter is released.
-- 
Regards,
Feri.
