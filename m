Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0CGM5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 07:57:33 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:35498 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0CGM5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 07:57:32 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: 07 Mar 2010 12:57:23 +0000
From: "J.I. Cameron" <jic23@cam.ac.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <Prayer.1.3.2.1003071257230.10684@hermes-2.csi.cam.ac.uk>
In-Reply-To: <20100307133426.54d38a93@hyperion.delvare>
References: <4B8C1867.7040201@cam.ac.uk>
 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
 <20100303184132.GA11471@core.coreip.homeip.net>
 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
 <20100303190753.GB11471@core.coreip.homeip.net>
 <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
 <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>
 <4B8F9727.6080907@cam.ac.uk>
 <20100307133426.54d38a93@hyperion.delvare>
X-Mailer: Prayer v1.3.2
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,
>On Thu, 04 Mar 2010 11:19:03 +0000, Jonathan Cameron wrote:
>> Anyhow, the way this conversation is going there appear to be several 
>> options and we need to make a decision before anyone wastes much more 
>> time.
>> 
>> 1) ALS as is. It's extremely light weight and can always be merged with 
>> a better
>>   option at a later date. If people prefer we can always stick it in a 
>> subdirectory
>>   called sensors or similar.
>
>This would be fine with me.
>
>> Perhaps move hwmon in there as well.
>
>I doubt it, especially if the interface to other sensors changes to
>treat them as input devices. At any rate, the hwmon interface is
>standardized since kernel ~2.6.5 and widely used, we're not going to
>change it now. So the benefit of sitting with other sensor type drivers
>is thin, probably thinner than the cost of the move.

Agreed. Though all I had in mind was some organization in Kconfig, not
actually changing hwmon in any real way.

>> 
>> 2) Input. I agree with Dmitry here. These devices are not within the 
>> scope as it
>>   currently exists. It can be done and there have been numerous 
>> discussions about
>>   doing so in the past (with various sensor types) and each time it has 
>> been decided
>>   that it isn't the right option.  Perhaps opinion on this has changed?
>
>I can't comment on this. It would seem reasonable to let the users
>(user-space applications) describe their needs and build the interface
>on top of that rather than the other away around. For this purpose,
>LKML doesn't seem like the right place to discuss. And I won't be the
>one driving the discussion anyway, I'm just a tourist here.

A fair point.  Can anyone suggest a suitable approach to getting opinions
here?  My use for these probably isn't terribly common (as it has nothing
to do with screens or input in the conventional sense given it is on a
small wireless mote.)

>
>> 3) Leave as is. Perhaps move all such drivers to misc and introduce 
>> some documentation
>>    in an attempt to standardize the interface they export. To all 
>> intents and purposes
>>    this is the core of als anyway. What we loose is a consistent 
>> location and device
>>    naming for userspace usage.
>
>No. I don't think it makes any sense. As you underline it yourself, it
>has all the issues ALS has, without the main benefit.
>
>> 4) Move them into IIO. They are within the scope we are covering. I 
>> agreed
>>   with the ALS subsystem when it was proposed as it was clean small and 
>> ready now
>>   not because I particularly wanted them out of IIO (there is still one 
>> there.)
>
>Fine with me as well.
>
>> Two comments on option 4: a) If we do it now rather than taking one of 
>> the other options and moving them later,
>>    then we are moving two perfectly good drivers out of the main tree 
>> into staging.
>>    Doesn't matter to me, may to others.
>
>Doesn't matter to me either, FWIW.
Cool.  If it is still homeless post merge window I'll pull the tsl2550
into IIO.  The isl20009 driver was originally going to go in there before
als came about, so shouldn't be any problem with that one.  For acpi
it's up to Zhang Rui.  If we can keep all the naming in new drivers
as per ALS it will simplify an eventual grouping of these device.
>
>> b) If anyone comes back later and says, 'IIO is a massively overweight 
>> subsystem for
>>    such simple drivers', then I reserve the right to get rather 
>> somewhat annoyed.
>>    We have always kept the core driver requirement (that needed for 
>> these drivers)
>>    as slim as possible. Of course suggestions on how to make it slimmer 
>> without
>>    breaking other functionality are welcome.
>> 
>> Please can anyone who feels like suggesting another general sensors 
>> subsystem at least taking a look at IIO (and keeping in mind we are in 
>> the middle of a big API cleanup). If you disagree with how we have done 
>> things, then contribute to the discussions and they may change.
>
>4 days left before I take care of driver tsl2550 myself.

Short of Linus changing his mind about ALS as is, I don't think any
of the other options are going to happen in time to merge this time round.
(what with testing any of the other options etc).

As you can do the tsl2550 as a simple move, I suggest you go ahead, and
we'll lift it from misc at a later date.

Thanks,

Jonathan

