Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0CHXU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:20:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:36971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CHXUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:20:54 -0500
Message-ID: <4B9586D3.2020109@kernel.org>
Date: Tue, 09 Mar 2010 08:22:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH 2/4] stop_machine: reimplement using cpuhog
References: <1268063603-7425-1-git-send-email-tj@kernel.org> <1268063603-7425-3-git-send-email-tj@kernel.org> <20100308190606.GB9149@redhat.com>
In-Reply-To: <20100308190606.GB9149@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Mar 2010 23:20:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 04:06 AM, Oleg Nesterov wrote:
> On 03/09, Tejun Heo wrote:
>>
>>  int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>>  {
>> ...
>> +	/* Set the initial state and hog all online cpus. */
>> +	set_state(&smdata, STOPMACHINE_PREPARE);
>> +	return hog_cpus(cpu_online_mask, stop_cpu, &smdata);
>>  }
> 
> Could you please confirm this is correct?
> 
> I am not sure I understand how the code looks with the patch applied,
> but the lockless set_state() above can confuse another stop_machine()
> in progress?

set_state() now modifies smdata->state and smdata is now local
variable of __stop_machine().  stop_machine instances don't have any
shared resource anymore.  Synchronization and resource sharing are all
cpuhog's responsibilities.

Thanks.

-- 
tejun
