Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZCCIxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZCCIxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZCCIxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:53:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZCCIxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:53:45 -0500
Message-ID: <49ACF049.8060306@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 16:54:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow cpusets to be configured/built on non-SMP systems
References: <20090303013432.11211.18662.stgit@menage.corp.google.com>		<49ACA13B.5050106@cn.fujitsu.com>		<6599ad830903022201s4d2296c7u225e84a77f9f7167@mail.gmail.com>	<6599ad830903030026w2081a72dhf3cac90346b1d806@mail.gmail.com> <49ACED6A.9060002@cn.fujitsu.com>
In-Reply-To: <49ACED6A.9060002@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Paul Menage wrote:
>> On Mon, Mar 2, 2009 at 10:01 PM, Paul Menage <menage@google.com> wrote:
>>> On Mon, Mar 2, 2009 at 7:17 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>>> +static int generate_sched_domains(struct cpumask **domains,
>>>>> +                     struct sched_domain_attr **attributes)
>>>>> +{
>>>> Except here should "return 0;", otherwise emit a compile warining.
>>>>
>>> Good catch - the weird thing is that (in my UML build) it doesn't
>>> actually generate that warning. Mysterious.
>>>
>>> I'll resend with the extra return.
>> After looking at the sched domains code it's not clear to me that
>> returning 0 is necessarily the right thing to do -
>> partition_sched_domains() says that 0 is a special case used for
>> destroying existing domains? Would returning 1 and setting up a single
>> dummy domain be better?
>>
> 

partition_sched_domains() says (0, NULL, ...) is used for destroying existing
domains, (1, NULL, ...) will fallback to the single default domain.

But partition_sched_domains() is a stub if !CONFIG_SMP

> Yes, return 1 seems more reasonable. And if we do this, should we also set
> *domains to NULL like this?
> 
> static int generate_sched_domains(struct cpumask **domains,
>                      struct sched_domain_attr **attributes)
> {
> 	*domains = NULL;
> 	return 1;
> }
> 
