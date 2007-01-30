Return-Path: <linux-kernel-owner+w=401wt.eu-S1750725AbXA3SnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750725AbXA3SnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXA3SnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:43:25 -0500
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:34212 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXA3SnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:43:24 -0500
Message-ID: <45BF91CA.9030609@tremplin-utc.net>
Date: Tue, 30 Jan 2007 19:43:22 +0100
From: Eric Piel <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
References: <20061219185223.GA13256@srcf.ucam.org> <200612201318.06976.david-b@pacbell.net> <20061221012924.GC32625@srcf.ucam.org> <200612201904.28681.david-b@pacbell.net> <20061221040648.GA1499@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org> <20070127131728.GB3942@ucw.cz>
In-Reply-To: <20070127131728.GB3942@ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

01/27/2007 02:17 PM, Pavel Machek wrote/a écrit:
> Hi!
> 
>> In 2.6.19, support for splitting driver suspend and resume callbacks 
>> into interrupt and non-interrupt contexts was added. Unfortunately, this 
>> broke /sys/device/.../power/state support for all devices. In the long 
>> run, this should be obsoleted by power management support in the 
>> individual drivers - however, in the case of network drivers (for 
>> example), currently only three drivers implement any sort of useful 
>> run-time power management.
> 
> Well... solution seems to be 'implement useful pm for more drivers'
> not 'discourage people from doing so by re-enabling broken interface'.
> 
>> --- a/Documentation/feature-removal-schedule.txt
>> +++ b/Documentation/feature-removal-schedule.txt
>> @@ -9,7 +9,8 @@ be removed from this file.
>>  What:	/sys/devices/.../power/state
>>  	dev->power.power_state
>>  	dpm_runtime_{suspend,resume)()
>> -When:	July 2007
>> +	bus->pm_has_noirq_stage()
>> +When:	Once alternative functionality has been implemented
> 
> .../power/state never worked properly. You have been warned and it is
> going to be removed. It oopses kernels... while 'only' providing power
> savings. If you are interested in power savings, please help doing
> them right.

Hi,
I realize that I'm arriving just far too late on this thread to bring 
any meaning, so that's just for the info...

I have been using this interface for a _long_ time (before june 2005, cf 
http://marc.theaimsgroup.com/?l=linux-usb-devel&m=111869558800526&w=2) 
and for different things than power saving: I can turn off my (usb) 
optical mouse when watching a movie or going to bed.

Is there any hardware independent alternative to turn off USB devices?

See you,
Eric
