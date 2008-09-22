Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYIVO4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYIVO4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYIVO40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:56:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYIVO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:56:25 -0400
Subject: Re: Re: [PATCH 4/13] memcg: force_empty moving account
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <19184326.1222095015978.kamezawa.hiroyu@jp.fujitsu.com>
References: <1222093420.16700.2.camel@lappy.programming.kicks-ass.net>
	 <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922200025.49ea6d70.kamezawa.hiroyu@jp.fujitsu.com>
	 <19184326.1222095015978.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 16:56:03 +0200
Message-Id: <1222095363.16700.15.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 23:50 +0900, kamezawa.hiroyu@jp.fujitsu.com wrote:
> ----- Original Message -----
> >> +			spin_lock_irqsave(&mz->lru_lock, flags);
> >> +		} else {
> >> +			unlock_page(page);
> >> +			put_page(page);
> >> +		}
> >> +		if (atomic_read(&mem->css.cgroup->count) > 0)
> >> +			break;
> >>  	}
> >>  	spin_unlock_irqrestore(&mz->lru_lock, flags);
> >
> >do _NOT_ use yield() ever! unless you know what you're doing, and
> >probably not even then.
> >
> >NAK!
> Hmm, sorry. cond_resched() is ok ?

depends on what you want to do, please explain what you're trying to do.


