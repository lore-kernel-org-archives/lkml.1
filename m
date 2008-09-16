Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbYIPLHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbYIPLHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 07:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYIPLHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 07:07:30 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:57253 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYIPLHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 07:07:30 -0400
Date: Tue, 16 Sep 2008 15:13:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Frank Mayhar <fmayhar@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       adobriyan@gmail.com, mingo@elte.hu, roland@redhat.com,
       tglx@linutronix.de
Subject: Re: + itimers-fix-itimer-many-thread-hang.patch added to -mm tree
Message-ID: <20080916111303.GA176@tv-sign.ru>
References: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org> <20080914175040.GA819@tv-sign.ru> <1221500983.19012.21.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221500983.19012.21.camel@bobble.smo.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15, Frank Mayhar wrote:
>
> I have a few more things to do; expect a new iteration of the patch
> tonight or tomorrow.

Great.

Please also remove tasklist_lock from thread_group_cputime_alloc_smp(),
it is not needed.

I'd also suggest to kill

	if (sig->cputime.totals)
		return 0;

, the caller has already checked this.


Please note also that thread_group_cputime_clone_thread() doesn't need
the second argument.


Very minor nit, but thread_group_cputime_alloc_smp() doesn't really
need get_cpu() + put_cpu_no_resched(), it can use smp_processor_id().

Oleg.

