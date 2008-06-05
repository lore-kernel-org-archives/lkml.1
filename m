Return-Path: <linux-kernel-owner+w=401wt.eu-S1763239AbYFDX7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763239AbYFDX7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbYFDX7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:59:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51418 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765AbYFDX7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:59:12 -0400
Date: Thu, 5 Jun 2008 09:04:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 2/2] memcg: hardwall hierarhcy for memcg
Message-Id: <20080605090425.35c9ac0b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080604213235.defb1d01.d-nishimura@mtf.biglobe.ne.jp>
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
	<20080604140329.8db1b67e.kamezawa.hiroyu@jp.fujitsu.com>
	<20080604213235.defb1d01.d-nishimura@mtf.biglobe.ne.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 21:32:35 +0900
Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> wrote:

> Hi.
> 
> > @@ -848,6 +937,8 @@ static int mem_cgroup_force_empty(struct
> >  	if (mem_cgroup_subsys.disabled)
> >  		return 0;
> >  
> > +	memcg_shrink_all(mem);
> > +
> >  	css_get(&mem->css);
> >  	/*
> >  	 * page reclaim code (kswapd etc..) will move pages between
> 
> Shouldn't it be called after verifying there remains no task
> in this group?
> 
> If called via mem_cgroup_pre_destroy, it has been verified
> that there remains no task already, but if called via
> mem_force_empty_wrte, there may remain some tasks and
> this means many and many pages are swaped out, doesn't it?
> 
you're right. I misunderstood where the number of children is checked.

Thanks,
-Kame


> 
> Thanks,
> Daisuke Nishimura.
> 

