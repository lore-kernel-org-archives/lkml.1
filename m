Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZBEUje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZBEUje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZBEUjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:39:21 -0500
Received: from mail.candelatech.com ([208.74.158.172]:54687 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZBEUjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:39:19 -0500
Message-ID: <498B4E44.9080607@candelatech.com>
Date: Thu, 05 Feb 2009 12:38:28 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: Re: PATCH:  Allow user to force 'tsc' to be treated as stable.
References: <498B42C5.7010905@candelatech.com> <20090205195945.GE3129@elte.hu>
In-Reply-To: <20090205195945.GE3129@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ben Greear <greearb@candelatech.com> wrote:
> 
>> Allow user to force TSC as stable clock-source.
>> Works around BIOS issues in the FWA-7304 (Via CN700 chipset)
>> system, and possibly others.
>>
>> This is against 2.6.29-rc3.
> 
> What 'issues' does that work around, exactly?

Without this, my system comes up with no stable high-res
clock, and the getnstimeofday seems to return something
with around 1ms granularity.  I have HZ set to 1000, so
its probably just using the 'jiffy' clocksource.
This in turn screws up my patched version of pktgen and
likely is sub-optimal for other things as well.

It seems the TSC on this system is stable, but I got lost
trying to understand the watchdog testing code, so I'm
not certain if it is wrong or not.  With this force in
place, the system seems stable and ran overnight under
network load fine.

Also, the BIOS on my system seems quite bad about filling out
tables, so that may be part of the root cause.

Thanks,
Ben


> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

