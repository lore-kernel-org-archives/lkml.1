Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbXEQIXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbXEQIXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 04:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXEQIXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 04:23:43 -0400
Received: from smtp3.versatel.nl ([62.58.50.90]:47151 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXEQIXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 04:23:42 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 04:23:41 EDT
Message-ID: <464C1302.1020608@hhs.nl>
Date: Thu, 17 May 2007 10:32:02 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_BREAK_MY_MACHINE
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>	<5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>	<alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>	<5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>	<20070514081022.7fcee97f@hyperion.delvare>	<5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>	<20070514141437.631fcfd1@hyperion.delvare>	<20070515203059.GI6816@ucw.cz> <20070516201143.699cff02@hyperion.delvare>
In-Reply-To: <20070516201143.699cff02@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Tue, 15 May 2007 20:31:00 +0000, Pavel Machek wrote:
>> Hi!
>>
>>>> Hardware Monitoring support  --->
>>>>   <*> Hardware Monitoring support
>>>>   <*> Abit uGuru
>>>>   <M> VIA686A
>>>>   <*> IBM Hard Drive Active Protection System (hdaps)
>>>>
>>>> But I'm quite sure that the only module used is VIA686A (I'm
>>>> rebuilding to confirm).
>>> This is a rather bad idea to build the abituguru and hdaps drivers into
>>> your kernel if you don't have these devices. Especially abituguru, as
>>> it does arbitrary port probing.
>> hdaps should be safe (DMI based whitelist, no?)
> 
> Correct.
> 
>> If abitguru breaks random machines, we probably should DMI whitelist,
>> too.
> 
> I never said it was breaking machines, just that it was accessing
> arbitrary I/O ports.
> 
> This was already discussed with the driver's author (Hans de Goede,
> Cc'd) and I think we agreed on the principle, but it didn't happen yet.
> This device only exists on Abit motherboards so it would be easy enough
> to check the DMI vendor. A more detailed white list is also possible,
> but I'm not insisting on it.
> 
> The driver could also be made to depend on X86, as this is the only
> architecture where it is useful.
> 
> Hans, can you please submit a patch doing this?
> 

As you can see from the CC I've send you, I've just mailed my private army of 
testers / known uguru users, requesting them to send me the output of dmidecode 
on their uguru mobo's. Once I have this info, I'll see if there is some 
consistency in the manufacturer DMI field.

I've mailed them, since the DMI info is needed anyways to put uguru detection 
in sensors-detect, but I'm not sure I want to add this to the driver too. Many 
other ISA drivers do io probe's too, if a users decides to start loading random 
drivers, he is asking for problems, should we really even try to protect 
against this?

Regards,

Hans

