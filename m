Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0CARwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:52:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:47070 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0CARwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:52:46 -0500
Message-ID: <4B8C014F.4040300@kernel.org>
Date: Tue, 02 Mar 2010 03:02:55 +0900
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
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-11-git-send-email-tj@kernel.org> <20100228141135.GB5495@redhat.com> <4B8BD822.1010402@kernel.org> <20100301153750.GA11090@redhat.com> <4B8BED09.7000904@kernel.org> <20100301165038.GA14558@redhat.com>
In-Reply-To: <20100301165038.GA14558@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 17:52:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/02/2010 01:50 AM, Oleg Nesterov wrote:
>> Oh, I see.  I was thinking get/put_online_cpus() block is exclusive
>> against cpu_maps_update_begin/done() instead of
>> cpu_hotplug_begin/done().  Will update and add comments.
> 
> Agreed, a little comment can help.
> 
> But, just in case, I forgot to repeat this case is not possible anyway.
> _cpu_down() ensures idle_cpu(cpu) == T after __stop_machine(), this means
> that this SCHED_FIFO thread we are going to kthread_stop() later can't
> be active.

Yeah, sure, that was what I was gonna write as comment.  :-)

Thanks for reviewing and see you tomorrow.  It's getting pretty late
(or early) here.  Bye.

-- 
tejun
