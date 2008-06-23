Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYFWAZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYFWAZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 20:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYFWAZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 20:25:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35807 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYFWAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 20:25:33 -0400
Date: Mon, 23 Jun 2008 09:30:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [Experimental][PATCH] putback_lru_page rework
Message-Id: <20080623093058.9976359f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080621175458.E82A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <1213981843.6474.68.camel@lts-notebook>
	<1213994489.6474.127.camel@lts-notebook>
	<20080621175458.E82A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008 17:56:17 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Quick update:  
> > 
> > With this patch applied, at ~ 1.5 hours into the test, my system panic'd
> > [panic_on_oops set] with a BUG in __find_get_block() -- looks like the
> > BUG_ON() in check_irqs_on() called from bh_lru_install() inlined by
> > __find_get_block().  Before the panic occurred, I saw warnings from
> > native_smp_call_function_mask() [arch/x86/kernel/smp.c]--also because
> > irqs_disabled().
> > 
> > I'll back out the changes [spin_[un]lock() => spin_[un]lock_irq()] to
> > shrink_inactive_list() and try again.  Just a hunch.
> 
> Yup.
> Kamezawa-san's patch remove local_irq_enable(), but don't remove
> local_irq_disable().
> thus, irq is never enabled.
> 

Sorry,
-Kame


> > -	spin_unlock(&zone->lru_lock);
> > +	spin_unlock_irq(&zone->lru_lock);
> >  done:
> > -	local_irq_enable();
> 
> 
> 

