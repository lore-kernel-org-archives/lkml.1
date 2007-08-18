Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbXHRUYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbXHRUYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 16:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXHRUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 16:24:06 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:5407 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXHRUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 16:24:04 -0400
Date: Sat, 18 Aug 2007 14:22:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: power off disk drives while running
In-reply-to: <fa.CQDcAiLY+yM/ENberToamsw+vFw@ifi.uio.no>
To: Brennan Ashton <comphappy@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Marty Leisner <leisner@rochester.rr.com>, linux-kernel@vger.kernel.org
Message-id: <46C7551E.7090408@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.l/ISoqsJwIs1QBGVs0hodyygNPM@ifi.uio.no>
 <fa.FVj1AVbAlk/6U33GB0rOY45WWqM@ifi.uio.no>
 <fa.CQDcAiLY+yM/ENberToamsw+vFw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brennan Ashton wrote:
> On 8/18/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>> On Aug 18 2007 12:08, Marty Leisner wrote:
>>> In embedded system design, it may be useful to poweroff the disks (as opposed
>>> to merely spinning them down).  We want to leave the system running while
>>> the disk is powered down, and let the disk powerup when it needs to be
>>> spun up.
>> That means you also have to power it on...
>>
>>> While the "power off mechanism" would be platform dependent, is there a
>>> generic path to announce "prepare for power going away"?
>> I do not see why that would be needed from a software point of view. Just make
>> sure that the disk does not needlessy emergency-park when pulling power. When
>> someone wants to write to disk, the request goes to the device driver, which
>> hands it to the controller, which hands it to the disk. And your controller
>> should be able to handle it (e.g. wait until reconnect) when there is a request
>> for a disk that is powered off.
>>
>>
>>         Jan
>> --
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> I see this a a very important feature in the embedded system relm, I
> have worked on two projects that required extreme power management,
> and massive data storage.  The ability to fully turn off a drive while
> the system is running is key. It seems like this should be able to be
> done from a kernel point of view rather than extra hardware. Although
> if is not in the IDE/SATA spec then extra hardware would be necessary.

You can put a drive into sleep mode with ATA commands, that one requires 
a reset to take it out of that state (as opposed to standby which spins 
down but will spin up on any command that's issued afterwards). That's 
as close as it gets to fully powering off a drive through software.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

