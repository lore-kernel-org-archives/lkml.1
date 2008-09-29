Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYI2IPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYI2IPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYI2IPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:15:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:56227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYI2IPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:15:40 -0400
Message-ID: <48E08E2D.6050905@kernel.org>
Date: Mon, 29 Sep 2008 17:13:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Gwendal Grignou <gwendal@google.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>	 <alpine.DEB.1.10.0809220404400.18908@p34.internal.lan>	 <5A4A9A3B0AAA4A20A33BC2D578F5F75F@909927SOSLA>	 <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>	 <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>	 <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>	 <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>	 <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>	 <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan> <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com> <48DBAB81.8050900@tmr.com>
In-Reply-To: <48DBAB81.8050900@tmr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Sep 2008 08:15:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Gwendal Grignou wrote:
>> About ata1:0 problem, as reported in the bugzilla bug: I would try to
>> disable NCQ to see if it helps. Your disks firmware might not fully
>> support it.
>>
>> You can either add the parameter "libata.force=noncq" when loading
>> your kernel, or set queue_depth to 1 for all the Seagate drives behind
>> the Marvell MV88SX6081 controller.
>>
>> About ata5:0 , someone - in user space probably - is trying to do a
>> SMART ENABLE operation, but the device ignores it. I don't know which
>> device you are using, but I assume it does not support ATA SMART
>> feature set. Timeout is an acceptable but not a nice way to answer, a
>> cancel would have been better; check if there is a firmware upgrade
>> for your device.
>>   
> 
> You certainly called the SMART issue, I was wondering why a new
> distribution install on some older hardware was getting all the errors,
> clearly the Fedora "smartd" doesn't check SMART capability before trying
> to enable the feature. Oddly the drive on which I see this does reply to
> SMART requests, so the firmware must be "semi-functional." Not a
> problem, in my case the drive is just used for testing handling of hot
> swap, and has no data of any value.

Can you post full kernel log including the boot messages and the error
messages?  Also, please attach the output of hdparm -I on the drive
which fails the smart command.

(cc'ing Bruce, hi!) Bruce, this is the second report I see about drive
timing out SMART ENABLE OPERATIONS.  Does anything ring a bell?

Thanks.

-- 
tejun
