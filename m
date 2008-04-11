Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYDKEul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYDKEul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYDKEud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:50:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:57611 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYDKEuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hRIupchtBvOfXh3BdkN/Qo1NCuf+ciIZs0YLZarNooaAJAJ1+1QTIu97VGNjqzzGQ1HDqXdic+aJJNuZo61eKt2UvMWG42EF2VPDbSl++GSE6J5/oIVVVe9dA9JCsuz2UY6+FE4SDrJYO4u6cINqjWtvTVmdumEQoyAQ6bdoK3s=
Message-ID: <47FEEE0E.6020206@gmail.com>
Date: Fri, 11 Apr 2008 13:50:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jason Baron <jbaron@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org,
       linuxdev-kanex@ml.css.fujitsu.com
Subject: Re: [patch 11/17] Implement immediate update via stop_machine_run
References: <20080409150829.855195878@polymtl.ca> <20080409152050.389300996@polymtl.ca> <20080410164159.2327.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080410200153.GB22894@Krystal>
In-Reply-To: <20080410200153.GB22894@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Mathieu,
>> it seems this patch is must, Why do you separate patch [10/17] and [11/17]?
>> this patch remove almost portion of [10/17].
>> IMHO these patch merge into 1 patch is better.
>>
>>     
>
> Hi Kosaki,
>
> You are right, I will merge them and resend them in the following post.
>   
Thanks

>>> +static int stop_machine_imv_update(void *imv_ptr)
>>> +{
>>> +	struct __imv *imv = imv_ptr;
>>> +
>>> +	if (!wrote_text) {
>>>       
>> it seems racy.
>> Why don't need test_and_set?
>>
>> I think your stop_machine_run(ALL_CPUS) call fn concurrency...
>>     
> The answer to this mistery is in include/linux/stop_machine.h modified
> by add-all-cpus-option-to-stop-machine-run.patch :
>
>
>  /**
>   * stop_machine_run: freeze the machine on all CPUs and run this function
>   * @fn: the function to run
>   * @data: the data ptr for the @fn()
> - * @cpu: the cpu to run @fn() on (or any, if @cpu == NR_CPUS.
> + * @cpu: if @cpu == n, run @fn() on cpu n
> + *       if @cpu == NR_CPUS, run @fn() on any cpu
> + *       if @cpu == ALL_CPUS, run @fn() first on the calling cpu, and then
> + *       concurrently on all the other cpus
>   *
>   * Description: This causes a thread to be scheduled on every other cpu,
>   * each of which disables interrupts, and finally interrupts are disabled
>
> Therefore, the first execution of the function is done before all other
> executions.
>
>   
Ah, OK. I understand.
Thanks.


