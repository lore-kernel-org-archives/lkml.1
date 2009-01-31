Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZAaKrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZAaKrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZAaKr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:47:28 -0500
Received: from ozlabs.org ([203.10.76.45]:59546 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZAaKr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:47:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/4] kthreads: move sched-realeted initialization from kthreadd context
Date: Sat, 31 Jan 2009 21:17:16 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
References: <20090130123350.GA26206@redhat.com>
In-Reply-To: <20090130123350.GA26206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901312117.17082.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 23:03:50 Oleg Nesterov wrote:
> (on top of kthread-dont-looking-for-a-task-in-create_kthread-2.patch)

Hi Oleg,

   Thanks for the cc: Vitaliy, I never saw that patch.  I've included it in my queue now.

As to this patch, it seems marginal.  I've never been convinced that we should
be trying to rescue root if they choose to set kthreadd's prio anyway, but I'm also wondering why we care about kthread_create scalability!

Still, I'm happy to apply it with one change:

> +		/*
> +		 * root may have changed our (kthreadd's) priority or CPU mask.
> +		 * The kernel thread should not inherit these properties.
> +		 */
> +		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
> +		set_user_nice(create.result, KTHREAD_NICE_LEVEL);
> +		set_cpus_allowed_ptr(create.result, CPU_MASK_ALL_PTR);

cpu_all_mask is the non-deprecated replacement for CPU_MASK_ALL_PTR.

Thanks!
Rusty.
