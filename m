Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143Ab0ATIvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0ATIvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902Ab0ATIvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:51:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0ATIvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:51:42 -0500
Subject: Re: [PATCH 04/40] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <4B56C047.6070808@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-5-git-send-email-tj@kernel.org>
	 <1263808570.4283.149.camel@laptop>  <4B54445E.302@kernel.org>
	 <1263814869.4283.296.camel@laptop>  <4B5505E2.4080203@kernel.org>
	 <1263890222.4283.634.camel@laptop>  <4B56C047.6070808@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 09:50:01 +0100
Message-ID: <1263977401.4283.819.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 17:35 +0900, Tejun Heo wrote:
> Hello,
> 
> On 01/19/2010 05:37 PM, Peter Zijlstra wrote:
> > On Tue, 2010-01-19 at 10:07 +0900, Tejun Heo wrote:
> >>
> >> It's also necessary to guarantee forward progress during CPU_DOWN.
> >> The problem with kthread_bind() is that it's not synchronized against
> >> CPU hotplug operations.  It needs outer synchronization like calling
> >> it directly from CPU_DOWN_PREP.  I guess it's doable but I think it
> >> would be better to simply share the backend implementation between
> >> set_cpus_allowed_ptr() and kthread_bind().
> > 
> > OK, so you're saying you need to migrate the rescue thread during
> > cpu-down. That thread is guaranteed sleeping right,
> 
> No, it's not.  It might have been tasked to process works from other
> CPUs.

OK, so maybe I'm confused, but in general the workqueue thing needs to
ensure work affinity, right? So why can we move the rescue thread while
its processing another CPU's works?

