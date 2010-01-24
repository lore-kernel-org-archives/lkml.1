Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233Ab0AXIOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0AXIOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 03:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538Ab0AXIOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 03:14:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:56639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab0AXIOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 03:14:37 -0500
Message-ID: <4B5C0266.1040406@kernel.org>
Date: Sun, 24 Jan 2010 17:18:46 +0900
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
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-5-git-send-email-tj@kernel.org>	 <1263808570.4283.149.camel@laptop>  <4B54445E.302@kernel.org>	 <1263814869.4283.296.camel@laptop>  <4B5505E2.4080203@kernel.org> <1263890222.4283.634.camel@laptop> <4B56C047.6070808@kernel.org>
In-Reply-To: <4B56C047.6070808@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 24 Jan 2010 08:12:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/20/2010 05:35 PM, Tejun Heo wrote:
> Wouldn't it make more sense to share the backend implementation
> between kthread_bind() and set_cpus_allowed_ptr() instead of making
> kthread_bind() a special case?  The goals of the two functions are
> basically identical.  Why have two separate implementations?
> kthread_bind() implementation as it currently stands is pretty fragile
> too.  Making kthread_bind() backed by set_cpus_allowed_ptr() will make
> it more robust and less error-prone and all that's necessary to
> achieve that is modifying sanity checks.

I gave it shot.  The interface is cleaner this way but I couldn't
figure out where to set PF_THREAD_BOUND as actual migration may happen
in different places and p->flags can only be set while it's known the
process is not running.  At this point, I can't think of a better way
to do this than the current patch.  :-(

Thanks.

-- 
tejun
