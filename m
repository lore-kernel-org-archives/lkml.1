Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab0CAQ2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:28:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:49542 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0CAQ2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:28:39 -0500
Message-ID: <4B8BED09.7000904@kernel.org>
Date: Tue, 02 Mar 2010 01:36:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 10/43] stop_machine: reimplement without using workqueue
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-11-git-send-email-tj@kernel.org> <20100228141135.GB5495@redhat.com> <4B8BD822.1010402@kernel.org> <20100301153750.GA11090@redhat.com>
In-Reply-To: <20100301153750.GA11090@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 16:25:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/02/2010 12:37 AM, Oleg Nesterov wrote:
>> Hmmm... I'm probably missing something but I don't see how
>> stop_machine_cpu_callback(CPU_POST_DEAD) depends on stop_cpu() thread
>> already parked in schedule().  Can you elaborate a bit?
> 
> Suppose that, when stop_machine_cpu_callback(CPU_POST_DEAD) is called,
> that stop_cpu() thread T is still running and it is going to check state
> before schedule().
> 
> CPU_POST_DEAD is called after cpu_hotplug_done(), another CPU can do
> stop_machine() and set STOPMACHINE_PREPARE.
> 
> If T sees state == STOPMACHINE_PREPARE it will join the game, but it
> wasn't counted in thread_ack counter, it is not cpu-bound, etc.

Oh, I see.  I was thinking get/put_online_cpus() block is exclusive
against cpu_maps_update_begin/done() instead of
cpu_hotplug_begin/done().  Will update and add comments.

Thanks.

-- 
tejun
