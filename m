Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYIZGsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYIZGsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYIZGsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:48:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33722 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbYIZGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:48:15 -0400
Date: Fri, 26 Sep 2008 15:54:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20080926155433.81eb520b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080926145422.327fb53f.nishimura@mxp.nes.nec.co.jp>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926100022.8bfb8d4d.nishimura@mxp.nes.nec.co.jp>
	<20080926104336.d96ab5bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926110550.2292287b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926145422.327fb53f.nishimura@mxp.nes.nec.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 14:54:22 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > >    There is a SwapCache which is referred from 2 process, A, B.
> > >    A maps it.
> > >    B doesn't maps it.
> > > 
> > >    And now, process A exits.
> > > 
> > > 	CPU0(process A)				CPU1 (process B)
> > >  
> > >     zap_pte_range()
> > >     => page remove from rmap			=> charge() (do_swap_page)
> > > 	=> set page->mapcount->0          	
> > > 		=> uncharge()			=> set page->mapcount=1
> > > 
> > > This race is what patch 12/12 is fixed.
> > > This only happens on cursed SwapCache.
> > > 
> > Sorry, my brain seems to be sleeping.. above page_mapped() check doesn't
> > help this situation. Maybe this page_mapped() check is not necessary
> > because it's of no use.
> > 
> > I think this kind of problem will not be fixed until we handle SwapCache.
> > 
> I've not fully understood yet what [12/12] does, but if we handle
> swapcache properly, [12/12] would become unnecessary?
> 
Maybe yes. we treat swapcache under lock_page().

> If so, how about handling swapcache instead of adding new interface?
> I think it can be done independent of mem+swap.
> 
Hmm, worth to be considered. But I'll reuse the interface itself for othres
(shmem, migrate, move_account etc)
But, in previous trial of SwapCache handling, we saw many troubles.
Then, I'd like to go carefully step by step to handle that.

Thanks,
-Kame

