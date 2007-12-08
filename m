Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXLHE4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXLHE4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXLHE4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:56:04 -0500
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:45214
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbXLHE4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:56:01 -0500
X-Authority-Analysis: v=1.0 c=1 a=Sv6w6hjq99wA:10 a=8VcNbOb3AAAA:8 a=2e0d3c8cEg8Gf7g1RScA:9 a=STDNQKfNByNDIalZtvzNgBWnKjUA:4 a=Dqp-bWOt5EsA:10
Message-ID: <475A23E0.90500@comcast.net>
Date: Fri, 07 Dec 2007 23:56:00 -0500
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86_64 dynticks not working   prev: cpuidle, dynticks compatible
 or no?
References: <fa.neCPfeOoC5rmM5re+ZzLHNAq2IU@ifi.uio.no> <fa.exjBuk8I+Vs1DPTCnfjHA4mJ5iE@ifi.uio.no> <475A148C.50100@shaw.ca>
In-Reply-To: <475A148C.50100@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Ed Sweetman wrote:
>> System is idle now, previously it was doing something i couldn't halt 
>> at the time.  I'm looking at "Local timer interrupts" in the "Loc:" 
>> section of /proc/interrupts.
>> Across 1 second while the system is pretty much idle, i still get 300 
>> interrupts. My HZ variable is set to 300 in the kernel config, so 
>> this is expected but I was under the assumption that 
>> dynticks/tickless being compiled in would cause that to be much lower.
>>
>> Am I reading the wrong section of /proc/interrupts  to verify if 
>> dynticks is working or not? Again, i see no difference in cpu temp at 
>> all.
>
> Try running powertop ( http://www.lesswatts.org/projects/powertop/ ) 
> and see what it reports.
>
> I don't think dynticks will generally save huge amounts of power on a 
> typical desktop machine. The big gains come from being able to stay in 
> deep sleep C-states (C2/C3) for longer periods of time, but most 
> desktop machines only enable sleep states down to C1.
>
I tried running powertop, it complains about not having timer 
statistics, I looked throughout the kernel config for a timer stat 
option, but can't find one.

I didn't have hpet compiled in, i'm not sure if this is required but a 
lot of places seem to suggest hpet and high precision timer and tickless 
be compiled together.  I also disabled cpuidle and i'll reboot and try 
that.



>>
>> In case it helps, this is an athlon64 x2 with apic functioning and 
>> both cores active in 64bit mode. dmesg is below.
>> not related :
>> Some additional notes:  it87 is my lm_sensor, it doesn't work in this 
>> kernel, yet it did in 2.6.22.  Perhaps enabling high precision timers 
>> changed something in acpi land.
>>
>> I enabled tcp dma offloading in this kernel, i get debugging output 
>> related to it, error is at the last line.  No corruption or otherwise 
>> bad behavior.   Transferring via cifs at 9.7MB/sec "incoming" took 
>> about 15% of one cpu...  I never bothered to check if that is the 
>> norm but i suspect i'll be removing that feature as it seems to not 
>> play nice with the kernel.
>

