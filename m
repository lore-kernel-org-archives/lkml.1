Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbZDHKn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbZDHKn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762732AbZDHKng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:43:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55028 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762697AbZDHKnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:43:35 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [1/4] x86: MCE: Make polling timer interval per CPU
From: Andi Kleen <andi@firstfloor.org>
References: <20090407506.675031434@firstfloor.org>
	<20090407150654.071D21D046E@basil.firstfloor.org>
	<49DC1D7E.4010802@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 12:43:28 +0200
In-Reply-To: <49DC1D7E.4010802@jp.fujitsu.com> (Hidetoshi Seto's message of "Wed, 08 Apr 2009 12:43:58 +0900")
Message-ID: <877i1va0j3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
>>  
>> @@ -632,14 +633,14 @@
>>  static void mce_init_timer(void)
>>  {
>>  	struct timer_list *t = &__get_cpu_var(mce_timer);
>> +	int *n = &__get_cpu_var(next_interval);
>>  
>> -	/* data race harmless because everyone sets to the same value */
>> -	if (!next_interval)
>> -		next_interval = check_interval * HZ;
>> -	if (!next_interval)
>
> [plan A]
> Add
> 	if (!check_interval)
> 		return;
>
> Or...
>
>> +	if (!*n)
>> +		*n = check_interval * HZ;
>> +	if (!*n)
>>  		return;


The !*n will return for check_interval == 0 because 0*HZ is still 0 so it should be 
equivalent. Did I miss something?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
