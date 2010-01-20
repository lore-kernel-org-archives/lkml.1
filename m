Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008Ab0ATI7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0ATI7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766Ab0ATI7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:59:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59487 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0ATI7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:59:51 -0500
Subject: Re: [PATCH 04/40] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <4B56C622.2030608@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-5-git-send-email-tj@kernel.org>
	 <1263808570.4283.149.camel@laptop>  <4B54445E.302@kernel.org>
	 <1263814869.4283.296.camel@laptop>  <4B5505E2.4080203@kernel.org>
	 <1263890222.4283.634.camel@laptop>  <4B56C047.6070808@kernel.org>
	 <1263977401.4283.819.camel@laptop>  <4B56C622.2030608@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 09:59:00 +0100
Message-ID: <1263977940.4283.821.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 18:00 +0900, Tejun Heo wrote:
> Hello,
> 
> On 01/20/2010 05:50 PM, Peter Zijlstra wrote:
> > OK, so maybe I'm confused, but in general the workqueue thing needs to
> > ensure work affinity, right? So why can we move the rescue thread while
> > its processing another CPU's works?
> 
> It doesn't get moved directly.  The CPU requests rescuer and rescuer
> will move itself to the CPU when it becomes idle.  We can of course
> make the rescuer wake up some other thread and then go to sleep and
> the other thread can kthread_bind() the rescuer to the dying CPU but
> that exactly is what the set_cpus_allowed_ptr() does.

Ah, ok I thought it was all mitigated through the management thread.

