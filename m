Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZFRHbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZFRHbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZFRHbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:31:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38901 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZFRHbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:31:08 -0400
Message-ID: <4A39ED3B.2060800@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 16:31:07 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/16] x86, mce: squash mce_intel.c into therm_throt.c
References: <4A3601BF.2000201@jp.fujitsu.com> <4A3605A2.6000206@jp.fujitsu.com> <851fc09e0906172249q40c99fc6n26662b533b063b9e@mail.gmail.com>
In-Reply-To: <851fc09e0906172249q40c99fc6n26662b533b063b9e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying wrote:
> 2009/6/15 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
>> move intel_init_thermal() into therm_throt.c
>>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>> ---
>>  arch/x86/kernel/cpu/mcheck/Makefile      |    2 +-
>>  arch/x86/kernel/cpu/mcheck/mce_intel.c   |   73 ------------------------------
>>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   66 +++++++++++++++++++++++++++
>>  3 files changed, 67 insertions(+), 74 deletions(-)
>>  delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c
> 
> Why we need this patch? I think the design principle behind MCE is to
> separate vendor/cpu specific code into different files. At least
> #ifdef CONFIG_X86_MCE_INTEL should be used around moved code.

Because at this time there are no vendor other than Intel that uses
thermal codes here.  I don't know much about AMD, whether there are
any plan to implement AMD specific thermal codes or not, and why they
have to make such specific thing here in future (patent?).

You can pull out "codes may not be shared" from therm_throt.c and
put it again into mce_intel.c (that was mce_intel_64.c).  But I
believe it is not needed now, until another code is available.
Or you can rename therm_throt.c to thermal_intel.c or so for a while.

(BTW, now CONFIG_X86_MCE_INTEL enables both of cmci and thermal,
 are there possible option to disable thermal while cmci is on?)


Thanks.
H.Seto

