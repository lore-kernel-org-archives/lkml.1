Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0BXBwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:52:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47950 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0BXBwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:52:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Feb 2010 10:48:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] memcg: page fault oom improvement v2
Message-Id: <20100224104839.6547ab78.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002231738070.3435@chino.kir.corp.google.com>
References: <20100223120315.0da4d792.kamezawa.hiroyu@jp.fujitsu.com>
	<20100223140218.0ab8ee29.nishimura@mxp.nes.nec.co.jp>
	<20100223152116.327a777e.nishimura@mxp.nes.nec.co.jp>
	<20100223152650.e8fc275d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100223155543.796138fc.nishimura@mxp.nes.nec.co.jp>
	<20100223160714.72520b48.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002231443410.8693@chino.kir.corp.google.com>
	<20100224090836.ba86a4a6.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002231738070.3435@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 17:42:33 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> > > 
> > > This allows us to hijack the TIF_MEMDIE bit to detect when there is a 
> > > parallel pagefault oom killing when the oom killer hasn't necessarily been 
> > > invoked to kill a system-wide task (it's simply killing current, by 
> > > default, and giving it access to memory reserves).  Then, we can change 
> > > out_of_memory(), which also now handles memcg oom conditions, to always 
> > > scan the tasklist first (including for mempolicy and cpuset constrained 
> > > ooms), check for any candidates that have TIF_MEMDIE, and return 
> > > ERR_PTR(-1UL) if so.  That catches the parallel pagefault oom conditions 
> > > from needlessly killing memcg tasks.  panic_on_oom would only panic after 
> > > the tasklist scan has completed and returned != ERR_PTR(-1UL), meaning 
> > > pagefault ooms are exempt from that sysctl.
> > > 
> > Sorry, I see your concern but I'd like not to do clean-up and bug-fix at
> > the same time.  
> > 
> > I think clean up after fix is easy in this case.
> > 
> 
> If you develop on top of my oom killer rewrite, pagefault ooms already 
> attempt to kill current first and then defer back to killing another task 
> if current is unkillable.  

After my fix, page_fault_out_of_memory is never called. (because memcg doesn't
return needless failure.)

Then, that's not point in this thread.

Thanks,
-Kame

