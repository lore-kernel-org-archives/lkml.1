Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYGLHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYGLHMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYGLHMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:12:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40789 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYGLHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:12:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu>
	<20080711203151.GU1678@linux-os.sc.intel.com>
	<86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com>
	<20080711204521.GA15689@elte.hu>
	<20080711212418.GV1678@linux-os.sc.intel.com>
	<86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com>
	<86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com>
	<m163rb4v3j.fsf@frodo.ebiederm.org>
	<86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com>
Date: Sat, 12 Jul 2008 00:02:54 -0700
In-Reply-To: <86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 11 Jul 2008 23:17:02 -0700")
Message-ID: <m1y7471t5t.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0056]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Fri, Jul 11, 2008 at 8:52 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>
>>> 1. wonder if x2apic can be use with uniprocessor.
>>>
>>> in APIC_init_uniprocessor, it will try to enable x2apic, but later
>>>
>>> apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
>>>
>>> but SET_APIC_ID is still for xapic version. so need to GET_APIC_ID,
>>> SET_APIC_ID for different
>>> genapic like 32bit.
>>>
>>> 2 check_x2apic is called in setup_arch, but it only set apic_ops,
>>> and genapic still not changed, aka apic_flat...
>>> wonder if you need to call setup_apic_routing to set genapic.
>>>
>>> otherwise read_apic_id could have use the one from apic_flat....need
>>> to shift......
>>>
>>> 3.or move read_apic_id to apic_ops intead...together with GET_APIC_ID too.
>>> but 32bit version seems like to put GET_APIC_ID with genapic...
>>>
>>> which one is better? 2 or 3
>>
>> Z finish untangle SMP support from apic initialization and move the apic
>> initialization up into init_IRQ.
>>
>> That is better but is likely the wrong short term approach.
>
> plan to add get_apic_id(x) into 64bit genapic, and will use
> #define GET_APIC_ID(x) genapic->get_apic_id(x)
> #define read_apic_id() GET_APIC_ID(apic_read(APIC_ID))
>
> so it is identical to 32bit, and we smooth the merging of 32/64 apic code
>
> also read the x2APIC spec pdf, it doesn't say anything about interrupt
> remapping...need to be used with x2apic...

Clustered logical mode won't work as it requires > 16 bits of apicid.
So only flat physical mode will work.

Eric
