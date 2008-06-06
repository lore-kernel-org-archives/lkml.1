Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYFFJyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYFFJyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYFFJyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:54:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbYFFJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:54:31 -0400
Date: Fri, 6 Jun 2008 02:54:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606025413.3772f21e.akpm@linux-foundation.org>
In-Reply-To: <20080606024811.70db9ab2.akpm@linux-foundation.org>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606002957.6329a0ec.akpm@linux-foundation.org>
	<20080606024811.70db9ab2.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 02:48:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 6 Jun 2008 00:29:57 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > It crashes on two quite different machines with both slab and slub.
> 
> OK, I seem to be screwed here.
> 
> Five commits to go and my bisection point is at

argh, that was copy-n-pasted from gitk which doesn't give the commit IDs.

> Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:13
> Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:08:00
> Parent: a9ad585c8a18f7ba754b85f5786976609b9d7d29 (x86: remove the static 256k node_to_cpumask_map)
> Branch: 
> Follows: v2.6.26-rc2
> Precedes: next-20080526

29657a44f8660acd8751d7e9f5aac06ec8633481
   x86: cleanup early per cpu variables/accesses v4
 
> But here I'm getting a totally different crash - an early exception.
> 
> I'll try a linear search starting at
> 
> Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
> Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:05:25
> Parent: b65e04b53ffcb4002737a5346c9ff8865c37be58 (x86: don't call pxm_to_node again)
> Child:  dfdf1d75efee39e9396f8384c6f3bf555349ed60 (x86: modify Kconfig to allow up to 4096 cpus)
> Branch: 

ff0e010ef613b0e7136f2f40ec4b51273676b085
   x86: fix remove cpu_pda table patch
 
> and ending at
> 
> Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:13
> Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:08:00
> Parent: a9ad585c8a18f7ba754b85f5786976609b9d7d29 (x86: remove the static 256k node_to_cpumask_map)
> Branch: 
> Follows: v2.6.26-rc2
> Precedes: next-20080526


78d49c6d890aee9cf8aea371011c9d7b0121b822
    x86: remove static boot_cpu_pda array v2
 
