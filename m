Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZCUL5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZCUL5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZCUL5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:57:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:35577 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbZCUL5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:57:34 -0400
Message-ID: <49C4D628.7060805@monstr.eu>
Date: Sat, 21 Mar 2009 12:57:28 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       john.williams@petalogix.com
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>  <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>  <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>  <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>  <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>  <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>  <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>  <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>  <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>  <49C2AB09.9040300@monstr.eu>  <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain>  <1237515861.7106.215.camel@jstultz-laptop>  <49C34558.6030006@monstr.eu> <1237581607.7191.51.camel@localhost.localdomain> <49C4C3BD.9090905@monstr.eu> <alpine.LFD.2.00.0903211206090.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903211206090.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 21 Mar 2009, Michal Simek wrote:
>> CONFIG_HZ_100=y
>> # CONFIG_HZ_250 is not set
>> # CONFIG_HZ_300 is not set
>> # CONFIG_HZ_1000 is not set
>> CONFIG_HZ=100
>>
>> For NO_HZ val I shouldn't use HZ value because of NO_HZ and HZ values shouldn't
>> be in .config file. Am I right?
> 
> No. NO_HZ does not remove the HZ value from the kernel. There is way
> too much code depending on it. What NO_HZ does is to supress the
> periodic tick when the system goes idle and the next timer expiry is
> farther away than 1 HZ. When the system is non idle then the periodic
> tick runs again. NO_HZ is merily for power saving.
> 
> In a normal kernel when the machine is idle then we wake up every HZ
> to find out that there is no work to do and we go idle again. But if
> you think about it then this is stupid, because the kernel knows when
> the next timer is due to expire. So if the next timer expiry is
> e.g. 100ms away, then we can sleep for full 100ms instead of sleeping
> 10 * 10ms (HZ=100) or 100 * 1ms (HZ=1000). This allows systems to go
> into deeper power saving states.
> 
> You should be able to observe the difference by monitoring
> /proc/interrupts. A nohz enabled kernel should have significantly less
> timer interrupts on an idle system.

Yes, I see it. I think I sent my log in any previous email in this thread too +
I see it on my heartbeat led too.

Thanks for explanation,
Michal
> 
> Thanks,
> 
> 	tglx


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
