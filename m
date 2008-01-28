Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYA1Ijg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYA1Ijg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYA1Ij2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:39:28 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:46460 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYA1Ij2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:39:28 -0500
Message-ID: <479D9483.9090907@aitel.hist.no>
Date: Mon, 28 Jan 2008 09:38:27 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: vatsa@linux.vnet.ibm.com, Tomasz Chmielewski <mangoo@wpkg.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
References: <479B69D2.5050603@wpkg.org> <200801271606.19862.toralf.foerster@gmx.de> <20080127165400.GB1044@linux.vnet.ibm.com> <200801271757.07743.toralf.foerster@gmx.de>
In-Reply-To: <200801271757.07743.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> At Sunday 27 January 2008 Srivatsa Vaddagiri wrote :
>   
>> You can set that to 0 to ask ondemand gov to include nice load into
>> account while calculating cpu freq changes:
>>
>> # echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load
>>
>> This should restore the behavior of ondemand governor as seen in 2.6.23
>> in your case (even with CONFIG_FAIR_GROUP_SCHED enabled). Can you pls confirm 
>> if that happens?
>>     
>
> Yes, of course, unfortunately this speeds up the CPU up to max power consumption
> which isn't wanted at least at a notebook b/c temperature and fan speed are at
> maximum in that case :-(
>
> It would be nice to run a grid application at lowest priority without impact to
> power / fan / temperature but OTOH have full performance for desktop
> applications, isn't it ?
>   
In theory, the fix is simple:
If _non-niced_ tasks use more than 80% of the cputime _made available to 
them_,
then  increase the processor speed.

The cputime allocated to niced tasks (that may be cpu intensive but 
shouldn't
cause max speed on their own) won't matter then.

Helge Hafting
