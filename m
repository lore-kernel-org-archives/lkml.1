Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXD1Mih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXD1Mih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 08:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965292AbXD1Mih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 08:38:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34007 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164AbXD1Mig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 08:38:36 -0400
Date: Sat, 28 Apr 2007 18:15:16 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070428124516.GA27292@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070425214704.GA32572@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425214704.GA32572@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 11:47:04PM +0200, Ingo Molnar wrote:
> The CFS patch against v2.6.21-rc7 or against v2.6.20.7 can be downloaded 
> from the usual place:
> 
>     http://redhat.com/~mingo/cfs-scheduler/

+static inline struct rb_node * first_fair(struct rq *rq)
+{
+	if (rq->rb_leftmost)
+		return rq->rb_leftmost;
+	return rb_first(&rq->tasks_timeline);
+}

Won't it help if you update rq->rb_leftmost above from the value
returned by rb_first(), so that subsequent calls to first_fair will be
sped up?

-- 
Regards,
vatsa
