Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbZANKzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbZANKzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbZANKyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:54:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbZANKyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:54:40 -0500
Subject: Re: [PATCH v2] sched: fix build error in kernel/sched_rt.c when
 RT_GROUP_SCHED && !SMP
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, rostedt@home.goodmis.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090114080111.GC18649@elte.hu>
References: <20090113014333.GA23448@elte.hu>
	 <20090113023345.32433.28954.stgit@dev.haskins.net>
	 <20090114080111.GC18649@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Jan 2009 11:54:36 +0100
Message-Id: <1231930476.7141.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 09:01 +0100, Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > +#define dec_rt_group(rt_se, rt_rq) do { } while (0)
> 
> Please dont _ever_ introduce new CPP macros into core kernel code, and if 
> you see existing once, please fix them to be proper C inline functions. 
> (there's a few other new macros in your patchset)

Generally good advice, and certainly doable in this case. But in some
very rare occasions I've had to use CPP in order to avoid silly header
dependency hell -- I think we should add comments in such cases as to
why we use CPP.
