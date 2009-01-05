Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZAEJOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZAEJOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZAEJN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:13:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZAEJN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:13:58 -0500
Message-ID: <4961CF1D.8090702@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 17:13:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] cpuset: don't allocate trial cpuset on stack
References: <495B2EA6.7010808@cn.fujitsu.com>	<495B2EC2.9090305@cn.fujitsu.com>	<495B2EE7.4040406@cn.fujitsu.com>	<495B2EFB.302@cn.fujitsu.com>	<495B2F19.7040806@cn.fujitsu.com> <20090104234659.19e62245.akpm@linux-foundation.org>
In-Reply-To: <20090104234659.19e62245.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -static int update_cpumask(struct cpuset *cs, const char *buf)
>> +static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>> +			  const char *buf)
>>  {
>>  	struct ptr_heap heap;
>> -	struct cpuset trialcs;
>>  	int retval;
>>  	int is_load_balanced;
>>  
>> @@ -891,8 +909,6 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
>>  	if (cs == &top_cpuset)
>>  		return -EACCES;
>>  
>> -	trialcs = *cs;
> 
> Yes, we already do.
> 
> That thing contains spinlocks and list_heads (at least), which cannot
> be copied in this way.
> 
> Seems that we're doing this gross thing because it just so happens that
> we only use the cpus_allowed and mems_allowed fields, and because

and also cpuset->flags.

> several of the called functions require a cpuset*, but only needed a
> cpumask_t.
> 
> How perfectly beastly.
> 

trial cpuset is used to ease the validation of changes to a cpuset. It
can be get rid of, but I'm afraid that the resulting code will be more
complex and less readable.
