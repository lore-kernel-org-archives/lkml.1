Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYEEOSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYEEOSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbYEEOSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:18:31 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:50240 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755951AbYEEOSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:18:31 -0400
Message-ID: <481F177A.4000300@seznam.cz>
Date: Mon, 05 May 2008 16:19:38 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 03/56] microblaze_v2: Cpuinfo handling
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>	 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>	 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu> <1209952342.5798.37.camel@localhost>
In-Reply-To: <1209952342.5798.37.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> --- /dev/null
>> +++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
>> @@ -0,0 +1,117 @@
> 
>> +
>> +	ci->cpu_clock_freq = fcpu(cpu, "timebase-frequency");
> 
> Should this be added to cpuinfo-pvr.c?

I moved it. This was in cpuinfo.c because you can't load frequency from PVR regs.
this value was loaded from DTS and I don't want to setup second parameter to pvr
function.

>> --- /dev/null
>> +++ b/include/asm-microblaze/cpuinfo.h
> ...
> 
>> +	/* HW debug support */
>> +	int hw_debug;
>> +	int num_pc_brk;
>> +	int num_rd_brk;
>> +	int num_wr_brk;
> 
>   +       /* CPU and system timebase info */
>> +	int cpu_clock_freq;
>> +
> 
>> +void set_cpuinfo_pvr_partial(struct cpuinfo *ci);
> 
> pvr_partial never got written - it can be deleted.

I removed it and changed values
M
