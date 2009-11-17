Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZKQHG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZKQHG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZKQHGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:06:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbZKQHGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:06:24 -0500
Message-ID: <4B024B18.40604@redhat.com>
Date: Tue, 17 Nov 2009 09:04:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, dhowells@redhat.com,
       arjan@linux.intel.com, torvalds@linux-foundation.org,
       peterz@infradead.org, andi@firstfloor.org,
       Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 01/21] workqueue: fix race condition in	schedule_on_each_cpu()
References: <1258391726-30264-1-git-send-email-tj@kernel.org> <1258391726-30264-2-git-send-email-tj@kernel.org> <20091116230427.GD5293@nowhere>
In-Reply-To: <20091116230427.GD5293@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 01:04 AM, Frederic Weisbecker wrote:
> On Tue, Nov 17, 2009 at 02:15:06AM +0900, Tejun Heo wrote:
>    
>> Commit 65a64464349883891e21e74af16c05d6e1eeb4e9 which allows
>> schedule_on_each_cpu() to be called from keventd added a race
>> condition.  schedule_on_each_cpu() may race with cpu hotplug and end
>> up executing the function twice on a cpu.
>>
>> Fix it by moving direct execution into the section protected with
>> get/put_online_cpus().  While at it, update code such that direct
>> execution is done after works have been scheduled for all other cpus
>> and drop unnecessary cpu != orig test from flush loop.
>>
>> Signed-off-by: Tejun Heo<tj@kernel.org>
>> Cc: Andi Kleen<ak@linux.intel.com>
>> Cc: Oleg Nesterov<oleg@redhat.com>
>> ---
>>      
>
> Shouldn't this patch go to .32 ?
> This looks like an important fix.
>    

Is anything using preeempt notifier on affected architectures?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

