Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843Ab0ATJu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0ATJu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955Ab0ATJuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:50:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38911 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0ATJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:50:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Jan 2010 18:47:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       kirill@shutemov.name
Subject: Re: [PATCH mmotm] memcg use generic percpu allocator instead of
 private one
Message-Id: <20100120184707.ed99b540.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B56CEF0.2040406@linux.vnet.ibm.com>
References: <20100120161825.15c372ac.kamezawa.hiroyu@jp.fujitsu.com>
	<4B56CEF0.2040406@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 15:07:52 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> On Wednesday 20 January 2010 12:48 PM, KAMEZAWA Hiroyuki wrote:
> > This patch is onto mmotm Jan/15.
> > =
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > When per-cpu counter for memcg was implemneted, dynamic percpu allocator
> > was not very good. But now, we have good one and useful macros.
> > This patch replaces memcg's private percpu counter implementation with
> > generic dynamic percpu allocator and macros.
> > 
> > The benefits are
> > 	- We can remove private implementation.
> > 	- The counters will be NUMA-aware. (Current one is not...)
> > 	- This patch reduces sizeof(struct mem_cgroup). Then,
> > 	  struct mem_cgroup may be fit in page size on small config.
> > 
> > By this, size of text is reduced.
> >  [Before]
> >  [kamezawa@bluextal mmotm-2.6.33-Jan15]$ size mm/memcontrol.o
> >    text    data     bss     dec     hex filename
> >   24373    2528    4132   31033    7939 mm/memcontrol.o
> >  [After]
> >  [kamezawa@bluextal mmotm-2.6.33-Jan15]$ size mm/memcontrol.o
> >    text    data     bss     dec     hex filename
> >   23913    2528    4132   30573    776d mm/memcontrol.o
> > 
> > This includes no functional changes.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
> Before review, could you please post parallel pagefault data on a large
> system, since root now uses these per cpu counters and its overhead is
> now dependent on these counters. Also the data read from root cgroup is
> also dependent on these, could you make sure that is not broken.
> 
No number difference before/after patch on my SMP quick test.
But I don't have NUMA. Could you test on NUMA ?

I'll measure again tomorrow if I have machine time.

Thanks,
-Kame



