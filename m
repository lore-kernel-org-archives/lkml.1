Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYEVQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYEVQNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYEVQM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:12:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35286
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754185AbYEVQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:12:58 -0400
Date: Thu, 22 May 2008 09:12:54 -0700 (PDT)
Message-Id: <20080522.091254.39363717.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: initialization of static per-cpu variables
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805221820.07290.rusty@rustcorp.com.au>
References: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com>
	<200805221820.07290.rusty@rustcorp.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 22 May 2008 18:20:06 +1000

> On Thursday 22 May 2008 04:28:02 Vegard Nossum wrote:
> > Hi,
> >
> > I encountered this comment in kernel/softirq.c:
> >
> > /* Some compilers disobey section attribute on statics when not
> >    initialized -- RR */
> > static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
> > static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
> >
> > So I assume it's the combination of static and whatever section
> > DFINE_PER_CPU puts the variable in which is the problem.
> >
> > However, there's a LOT of these "static DEFINE_PER_CPU" without any
> > initializer in the rest of the code, e.g.:
> 
> Yep, it was an old toolchain used by Sparc: DaveM found this one.  As you say, 
> it's ancient: I'm happy to queue a cleanup patch now everyone is on a modern 
> compiler.

Yes, that workaround certainly can die now.
