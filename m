Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZKTGZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZKTGZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 01:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZKTGZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 01:25:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:34941 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZKTGZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 01:25:06 -0500
Message-ID: <4B063614.5030105@kernel.org>
Date: Fri, 20 Nov 2009 15:24:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       peterz@infradead.org, johannes@sipsolutions.net
Subject: Re: [PATCH 07/19] acpi: use queue_work_on() instead of binding workqueue
 worker to cpu0
References: <1258692407-8985-1-git-send-email-tj@kernel.org>	<1258692407-8985-8-git-send-email-tj@kernel.org> <20091119210909.b112bc77.akpm@linux-foundation.org>
In-Reply-To: <20091119210909.b112bc77.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/20/2009 02:09 PM, Andrew Morton wrote:
>> -	kacpid_wq = create_singlethread_workqueue("kacpid");
>> -	bind_workqueue(kacpid_wq);
>> -	kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
>> -	bind_workqueue(kacpi_notify_wq);
>> -	kacpi_hotplug_wq = create_singlethread_workqueue("kacpi_hotplug");
>> -	bind_workqueue(kacpi_hotplug_wq);
>> +	kacpid_wq = create_workqueue("kacpid");
>> +	kacpi_notify_wq = create_workqueue("kacpi_notify");
>> +	kacpi_hotplug_wq = create_workqueue("kacpi_hotplug");
> 
> Well that sucks.  We create an additional ((num_possible_cpus()-1)*3)
> kernel threads just because the previous code was "unorthodox"?
> 
> I guess that problem goes away with concurrency-managed workqueues. 
> But please let's not merge this patch without also merging
> concurrency-managed workqueues!

Yeah, it's just prepping the code for the conversion to concurrency
managed workqueues.  I'll put this into linux-next for some time
without full conversion but it will never go upstream without it.

Thanks.

-- 
tejun
