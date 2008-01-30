Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbYA3OSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbYA3OSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbYA3OSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:18:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763436AbYA3OR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:17:58 -0500
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, ebiederm@xmission.com, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080129150209.663538cb.akpm@linux-foundation.org>
References: <20080129164019.GA2060@tv-sign.ru>
	 <20080129150209.663538cb.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 15:17:33 +0100
Message-Id: <1201702653.28547.219.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 15:02 -0800, Andrew Morton wrote:
> On Tue, 29 Jan 2008 19:40:19 +0300
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
> 
> I'm suspecting that we have other code which assumes that read_lock, write_lock
> and spin_lock imply rcu_read_lock().
> 
> I wonder if there are any sane runtime checks we can put in there to find
> such problems.

I have a lockdep annotation that finds rcu_dereference() usages outside
of rcu_read_lock().

Trouble is the amazing amount of output, I haven't come round to going
through it and annotation the false positives (think rcu safe library
routines called from contexts where the rcu capability is not used).



