Return-Path: <linux-kernel-owner+w=401wt.eu-S1031040AbXFHRhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031040AbXFHRhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbXFHRh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:37:27 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:35592 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbXFHRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:37:26 -0400
Message-ID: <466993CF.4050804@de.ibm.com>
Date: Fri, 08 Jun 2007 19:37:19 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, jbaron@redhat.com, rostedt@goodmis.org,
       billh@gnuppy.monkey.org, mingo@elte.hu, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <1181202258.7348.217.camel@twins> <46698B1D.3000806@de.ibm.com> <1181322460.5728.2.camel@lappy> <46698F7F.4090407@de.ibm.com> <1181323622.5728.6.camel@lappy>
In-Reply-To: <1181323622.5728.6.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2007-06-08 at 19:18 +0200, Martin Peschke wrote:
>> Peter Zijlstra wrote:
>>> On Fri, 2007-06-08 at 19:00 +0200, Martin Peschke wrote:
>>>> Peter Zijlstra wrote:
>>>>> I'm confused as to where the class->stat objects are initialised? Is
>>>>> that done in lock_stat_init()? If so, then you have a bug.
>>>> static struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
>>>>
>>>> I assume this gets us class structures containing all zeros, doesn't it?
>>>> Then class->stat is zeros as well, which is handled by lib/statistics.
>>>> (In this case, data gathering hasn't been turned on yet, and statistic_inc()
>>>> and similar functions don't access other areas of struct statistic.)
>>> Who eventually calls percpu_alloc?
>> There is a small state machine calling percpu_alloc when users do
>>
>>     echo state=on > /debug/statistics/lockdep/definition
>>
>> So data gathering is off by default.
>>
>> It might make sense to allow "state=on" as a default. Then allocation would
>> be done in the context of statistic_attach().
> 
> Right, the problem here is that you iterate over all_lock_classes once
> at init.
> 
> Contrary to what the name might suggest, it are not all possible
> classes, just all active ones. So you'll only attach the classes which
> have been used up until the init point. All other classes used later
> will never be initialized.

Ah..

Do you know where a class is setup for first use?
I guess it is feasible to move statistic initialisation to that place.

Is there a place where a class becomes unused again?


