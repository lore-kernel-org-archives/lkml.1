Return-Path: <linux-kernel-owner+w=401wt.eu-S2992797AbXDDJwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992797AbXDDJwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992800AbXDDJwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:52:33 -0400
Received: from mail.screens.ru ([213.234.233.54]:49832 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992797AbXDDJwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:52:32 -0400
Date: Wed, 4 Apr 2007 12:57:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Paul Jackson <pj@sgi.com>
Subject: Re: getting processor numbers
Message-ID: <20070404085700.GA170@tv-sign.ru>
References: <461286D6.2040407@redhat.com> <20070403131623.c6831607.akpm@linux-foundation.org> <4612BB89.8040102@redhat.com> <20070403141348.9bcdb13e.akpm@linux-foundation.org> <4612D175.30604@redhat.com> <20070403154831.37bde672.akpm@linux-foundation.org> <4612DCA2.2090400@redhat.com> <20070403162349.583adf84.akpm@linux-foundation.org> <20070404083927.GA100@tv-sign.ru> <20070404093948.GA14521@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404093948.GA14521@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > But we don't need tasklist_lock at all, we can use 
> > rcu_read_lock/unlock. Q: don't we need task_rq_lock() to read 
> > ->cpus_allowed "atomically" ?
> 
> right now ->cpus_allowed is protected by tasklist_lock. We cannot do RCU 
> here because ->cpus_allowed modifications are not RCUified.

Is it so? that was my question. Afaics, set_cpus_allowed() does
p->cpus_allowed = new_mask under rq->lock, so I don't understand
how tasklist_lock can help.

Could you clarify?

Oleg.

