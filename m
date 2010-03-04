Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0CDO63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:58:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0CDO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:58:27 -0500
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy
 and mems_allowed
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Miao Xie <miaox@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>, tglx <tglx@linutronix.de>
In-Reply-To: <20100304033017.GN8653@laptop>
References: <4B8E3F77.6070201@cn.fujitsu.com> <20100304033017.GN8653@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 15:58:24 +0100
Message-ID: <1267714704.25158.199.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 14:30 +1100, Nick Piggin wrote:
> 
> Thanks for working on this. However, rwlocks are pretty nasty to use
> when you have short critical sections and hot read-side (they're twice
> as heavy as even spinlocks in that case). 

Should we add a checkpatch.pl warning for them? 

There really rarely is a good case for using rwlock_t, for as you say
they're a pain and often more expensive than a spinlock_t, and if
possible RCU has the best performance.

