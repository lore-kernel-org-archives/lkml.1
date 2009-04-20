Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZDTJFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZDTJFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZDTJFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:05:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33630 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbZDTJFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:05:32 -0400
Message-ID: <49EC3AC0.8070109@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 18:05:04 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH -tip 3/3] x86, mce: Add new option mce=no_cmci
 and mce=ignore_ce
References: <49EBCDB0.7000505@jp.fujitsu.com>	<49EBCF87.4090608@jp.fujitsu.com> <87myabpyrn.fsf@basil.nowhere.org>
In-Reply-To: <87myabpyrn.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
> 
>> This patch introduces a couple of boot option for x86_64 mce.
>>
>> The "mce=no_cmci" boot option disables cmci feature.
>> Since cmci is a new feature so having boot controls to disable
>> it will be a help if the hardware is misbehaving.
> 
> Acked-by: Andi Kleen <ak@linux.intel.com>
> 
> Although I expect on Nehalem you'll get more problems without CMCI
> than with due to the shared banks. Perhaps the documentation
> should make that clearer.

Good idea.  I'll add it to boot-options.txt

>> The "mce=ignore_ce" boot option disables features for corrected
>> errors, i.e. polling timer and cmci.  Usually this disablement
>> is not recommended, however it will be a help if there are some
>> conflict with the BIOS or hardware monitoring applications etc.
> 
> Same problem as with the earlier patch.  You need a point
> somewhere where the event is cleared, otherwise all hell
> breaks loose.

Adding "dont_log_ce" and its description will be a help.
It need to describe how it different from ignore_ce and how events
are cleared.

>>  static int mce_dont_init;
>> +int cmci_disabled;
>> +int ignore_ce;
> 
> For global variables you should use a mce_ prefix to not pollute
> global name space.

OK.  I'll fix.

>> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
>> index d6b72df..64c0dd9 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
>> @@ -109,6 +109,9 @@ static int cmci_supported(int *banks)
>>  {
>>  	u64 cap;
>>  
>> +	if (cmci_disabled | ignore_ce)
> 
> I presume you meant || here

Yes, should be fixed.


Thanks,
H.Seto

