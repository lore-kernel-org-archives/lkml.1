Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYFLJAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYFLJAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYFLI7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:59:54 -0400
Received: from www.tglx.de ([62.245.132.106]:59829 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYFLI7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:59:54 -0400
Date: Thu, 12 Jun 2008 10:56:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
In-Reply-To: <20080611204917.523866467@mvista.com>
Message-ID: <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com> <20080611204917.523866467@mvista.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, Daniel Walker wrote:
> Adds an additional function call to the sched_setscheduler to update the
> waiter position of a task if it happens to be waiting on a futex. This
> ensures that the kernel level waiter ordering is correctly maintained
> based on the changed priority of the task.
> 
> I fixed the locking issue noticed by Thomas Gleixner.
> 
> This doesn't address userspace at all, only the kernel level wakeups and
> kernel level ordering.
> 
> The additional locking added to the futex_wait function has no visible speed
> impact, and only effects waiters which actual enter the kernel.

The additional locking is just broken and you did not even bother to
test your changes with lockdep.

Aside of this, these patches still add 100 lines of code to achieve
nothing - as dicussed when you previously submitted your changes. 

Please stop wasting everyone's time with that.

Thanks,

	tglx
