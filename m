Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXLJIPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXLJIPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXLJIPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:15:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:23705 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXLJIPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CIk0mixhYYKEQLmYjw2LS3mveOmeZAK9u0ugAUB73M6lTqUAeuisANC4EX3CJw/dVEz8DAclwAaH84blbaweJVlXRXzSf3ZIcjB3fc7qu/ohV0RFg0c/BoT0xQqbYyMSnyKLQs6sFPRq8cdnZzVKsIIDDK5jGBPYsuVkQbi8XDc=
Message-ID: <475CF57E.7060406@gmail.com>
Date: Mon, 10 Dec 2007 17:14:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       apiszcz@solarrain.com
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan> <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr> <4751AB91.2000207@tmr.com>
In-Reply-To: <4751AB91.2000207@tmr.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Jan Engelhardt wrote:
>> On Dec 1 2007 06:26, Justin Piszcz wrote:
>>> I ran the following:
>>>
>>> dd if=/dev/zero of=/dev/sdc
>>> dd if=/dev/zero of=/dev/sdd
>>> dd if=/dev/zero of=/dev/sde
>>>
>>> (as it is always a very good idea to do this with any new disk)
>>
>> Why would you care about what's on the disk? fdisk, mkfs and
>> the day-to-day operation will overwrite it _anyway_.
>>
>> (If you think the disk is not empty, you should look at it
>> and copy off all usable warez beforehand :-)
>>
> Do you not test your drive for minimum functionality before using them?

I personally don't.

> Also, if you have the tools to check for relocated sectors before and
> after doing this, that's a good idea as well. S.M.A.R.T is your friend.
> And when writing /dev/zero to a drive, if it craps out you have less
> emotional attachment to the data.

Writing all zero isn't too useful tho.  Drive failing reallocation on
write is catastrophic failure.  It means that the drive wanna relocate
but can't because it used up all its extra space which usually indicates
something else is seriously wrong with the drive.  The drive will have
to go to the trash can.  This is all serious and bad but the catch is
that in such cases the problem usually stands like a sore thumb so
either vendor doesn't ship such drive or you'll find the failure very
early.  I personally haven't seen any such failure yet.  Maybe I'm lucky.

Most data loss occurs when the drive fails to read what it thought it
wrote successfully and the opposite - reading and dumping the whole disk
to /dev/null periodically is probably much better than writing zeros as
it allows the drive to find out deteriorating sector early while it's
still readable and relocate.  But then again I think it's an overkill.

Writing zeros to sectors is more useful as cure rather than prevention.
 If your drive fails to read a sector, write whatever value to the
sector.  The drive will forget about the data on the damaged sector and
reallocate and write new data to it.  Of course, you lose data which was
originally on the sector.

I personally think it's enough to just throw in an extra disk and make
it RAID0 or 5 and rebuild the array if read fails on one of the disks.
If write fails or read fail continues, replace the disk.  Of course, if
you wanna be extra cautious, good for you.  :-)

-- 
tejun
