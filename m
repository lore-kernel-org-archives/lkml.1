Return-Path: <linux-kernel-owner+w=401wt.eu-S1751478Ab0ATIzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab0ATIzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237Ab0ATIzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:55:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:36903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab0ATIy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:54:59 -0500
Message-ID: <4B56C622.2030608@kernel.org>
Date: Wed, 20 Jan 2010 18:00:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 04/40] sched: implement __set_cpus_allowed()
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-5-git-send-email-tj@kernel.org>	 <1263808570.4283.149.camel@laptop>  <4B54445E.302@kernel.org>	 <1263814869.4283.296.camel@laptop>  <4B5505E2.4080203@kernel.org>	 <1263890222.4283.634.camel@laptop>  <4B56C047.6070808@kernel.org> <1263977401.4283.819.camel@laptop>
In-Reply-To: <1263977401.4283.819.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 08:54:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/20/2010 05:50 PM, Peter Zijlstra wrote:
> OK, so maybe I'm confused, but in general the workqueue thing needs to
> ensure work affinity, right? So why can we move the rescue thread while
> its processing another CPU's works?

It doesn't get moved directly.  The CPU requests rescuer and rescuer
will move itself to the CPU when it becomes idle.  We can of course
make the rescuer wake up some other thread and then go to sleep and
the other thread can kthread_bind() the rescuer to the dying CPU but
that exactly is what the set_cpus_allowed_ptr() does.

Thanks.

-- 
tejun
