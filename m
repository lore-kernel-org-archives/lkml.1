Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbXJXSJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbXJXSJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXJXSJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:09:16 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51460 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbXJXSJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:09:15 -0400
Date: Wed, 24 Oct 2007 22:14:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 4/5] Remove CPU_DEAD/CPU_UP_CANCELLED handling from workqueue.c
Message-ID: <20071024181421.GB345@tv-sign.ru>
References: <20071024052931.GA22722@in.ibm.com> <20071024053716.GD27074@in.ibm.com> <20071024133818.GA82@tv-sign.ru> <20071024174553.GA8663@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024174553.GA8663@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Gautham R Shenoy wrote:
>
> On Wed, Oct 24, 2007 at 05:38:18PM +0400, Oleg Nesterov wrote:
> > 
> > So, can't we introduce 2 nested rw locks? The first one blocks cpu hotplug
> > (like get_online_cpus does currently), the second one just pins cpu maps.
> > I think most users needs only this, not more.
> > 
> 
> Well, rw locks/sems cannot recurse. However, refcount model supports
> recursion naturally. Hence the implementation.

No, no, you misunderstood! (I was unclear). I meant, can't we introduce 2
refcounted nested locks? Both implemented as get_online_cpus/cpu_hotplug_begin.

Oleg.

