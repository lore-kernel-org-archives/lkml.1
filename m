Return-Path: <linux-kernel-owner+w=401wt.eu-S1762601AbZLPS5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762601AbZLPS5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZLPS5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:57:50 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47222 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZLPS5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LoYSkEvUmVtfqjTQpFsErHQG65y3LBg4wPm+lDRsw7pbBxdxMGXm52q7D3/EoEpV1l
         Vsa3htWlal1Cuf6vBGlxyB97rQ48Db3XAkYEPV2/sRuDI7kocCXi/edB522sAKuJZXlx
         LbN8T+bWwzuFLCgOLnAttcpCai0tYUfOSjvlE=
Date: Wed, 16 Dec 2009 19:57:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de
Subject: Re: [tip:sched/urgent] sched: Teach might_sleep() about
	preemptible RCU
Message-ID: <20091216185723.GA5211@nowhere>
References: <1260830672-7166-1-git-send-regression-fweisbec@gmail.com> <tip-ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd@git.kernel.org> <20091216142536.GA18091@elte.hu> <20091216153020.GD6744@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216153020.GD6744@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 07:30:20AM -0800, Paul E. McKenney wrote:
> On Wed, Dec 16, 2009 at 03:25:36PM +0100, Ingo Molnar wrote:
> > 
> > * tip-bot for Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Commit-ID:  ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd
> > > Gitweb:     http://git.kernel.org/tip/ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd
> > > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > > AuthorDate: Mon, 14 Dec 2009 23:44:32 +0100
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Wed, 16 Dec 2009 08:43:16 +0100
> > > 
> > > sched: Teach might_sleep() about preemptible RCU
> > 
> > Causes a build failure, so skipped this patch for now:
> > 
> > kernel/sched.c:9661: error: implicit declaration of function 'rcu_preempt_depth'
> 
> I guess my testing missed something.  :-/  Could you please send the
> .config file that caused this?
> 
> 							Thanx, Paul


Looks like the problem is here:

rcupdate.h:

	#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
	#include <linux/rcutree.h>
	#elif defined(CONFIG_TINY_RCU)
	#include <linux/rcutiny.h>

I guess it barfs in rcutiny configs.

I should define these helpers in rcupdate.

