Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXJNVFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXJNVFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759361AbXJNVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:05:41 -0400
Received: from customer-vserver-jkruis-1.all2all.org ([62.58.108.47]:45309
	"EHLO jkruis.all2all.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759123AbXJNVFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:05:40 -0400
Message-ID: <471284A7.1060800@samwel.tk>
Date: Sun, 14 Oct 2007 23:05:43 +0200
From: Bart Samwel <bart@samwel.tk>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: crash@treysoft.com
CC: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: hdparm standby timeout not working for WD raptors?
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>	 <470E7B90.5060203@rtr.ca>	 <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>	 <470F7705.3@rtr.ca>	 <71b295590710121519i55d3471fha16210e698094bec@mail.gmail.com>	 <47120D65.3080008@samwel.tk> <71b295590710141330g7a4779e5q2d6b8f50387ee971@mail.gmail.com>
In-Reply-To: <71b295590710141330g7a4779e5q2d6b8f50387ee971@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Weber wrote:
> On 10/14/07, Bart Samwel <bart@samwel.tk> wrote:
>> Some things to check:
>>
>> * Run "hdparm -I" on your drive. In the "Capabilities" section there is
>> a line "Standby timer values", for some drives this mentions a device
>> specific minimum. I know some drives that ignore any setting below 60
>> seconds.
>>
>> * I also know of quite a number of drives where hdparm -B settings
>> override the -S settings, even if you set the -S settings after the
>> hdparm -B settings. You could try combinations with various values of
>> hdparm -B, especially 1 and 255.
> 
> Thanks for the suggestions.
> 
> The -I command prints out a bunch of stuff including:
> Standby timer values: spec'd by Standard, with device specific minimum

Ahhh. Spec'd by standard means that each -S unit is worth 5 seconds (for 
values up to 240 = 20 minutes), and the second part means that there is 
a minimum (which is not specified in this report, unfortunately). 
Perhaps you can get a hold of the full drive manual, the exact minimum 
value is probably specified there.

> I tried setting -B to 1 and and then set -S to 5 minutes.
> Also, -B 255 and then set -S to 5 minutes.
> No luck with either. These drives want to keep running.

Just to be sure: you did use -S 60 to get 5 minutes, right?

> One thing of possible interest: The -B command printed
> the following message:
> 
> /dev/sda:
>  setting Advanced Power Management level to 0x01 (1)
>  HDIO_DRIVE_CMD failed: Input/output error
> 
> I would guess that the first line came out just before
> hdparm tried to do the set, and the second line indicates
> that the set failed.

Yes, that seems correct. Nothing too weird there: it simply seems that 
the drive doesn't support the power management knob. (AFAIK you should 
be able to confirm this using the feature sets listed in the output of 
hdparm -I.)

> Perhaps -S is failing too, just without the diagnostic?

Perhaps, but I'd expect it to print a diagnostic if it fails. I do seem 
to remember that (at least for some drives that I've seen) there isn't a 
diagnostic if you go below the device specific minimum, the value is 
simply ignored.

Cheers,
Bart
