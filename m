Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZKMCho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZKMCho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 21:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZKMChk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 21:37:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37767 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbZKMChj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 21:37:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 Nov 2009 11:35:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] show per-process swap usage via procfs v3
Message-Id: <20091113113502.9c5a93b7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091113105112.c72cf8f5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360911050711k47a63896xe4915157664cb822@mail.gmail.com>
	<20091106084806.7503b165.kamezawa.hiroyu@jp.fujitsu.com>
	<20091106134030.a94665d1.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360911060719y45f4b58ex2f13853f0d142656@mail.gmail.com>
	<20091111112539.71dfac31.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.10.0911121017180.28271@V090114053VZO-1>
	<20091113105112.c72cf8f5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 10:51:12 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > @@ -597,7 +600,9 @@ copy_one_pte(struct mm_struct *dst_mm, s
> > >  						 &src_mm->mmlist);
> > >  				spin_unlock(&mmlist_lock);
> > >  			}
> > > -			if (is_write_migration_entry(entry) &&
> > > +			if (!non_swap_entry(entry))
> > > +				rss[2]++;
> > > +			else if (is_write_migration_entry(entry) &&
> > >  					is_cow_mapping(vm_flags)) {
> > >  				/*
> > 
> > What are the implications for fork performance?
> 
> This path is executed when page table entry contains a entry of
>   !pte_none() && !pte_present().
> 
> There are not very big chance to reach here.(this path is under unlikely()).
> 

[before]
 text    data     bss     dec     hex filename
6649003 3221828 10232816        20103647        132c1df vmlinux
[after]
   text    data     bss     dec     hex filename
6649243 3221828 10232816        20103887        132c2cf vmlinux

Now, 240 bytes of text size..Hmm.

Thanks,
-Kame

