Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYFDMzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYFDMzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYFDMy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:54:58 -0400
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.68]:52514 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYFDMy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:54:57 -0400
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Wed, 4 Jun 2008 21:53:34 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Paul Menage" <menage@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 2/2] memcg: hardwall hierarhcy for memcg
Message-Id: <20080604215334.9f3a249b.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20080604182626.fcc26e24.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
	<20080604140329.8db1b67e.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830806040159w1026003fhe3212beac895927a@mail.gmail.com>
	<20080604182626.fcc26e24.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > @@ -1096,6 +1238,12 @@ static void mem_cgroup_destroy(struct cg
> > >        int node;
> > >        struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
> > >
> > > +       if (cont->parent &&
> > > +           mem->hierarchy_model == MEMCG_HARDWALL_HIERARCHY) {
> > > +               /* we did what we can...just returns what we borrow */
> > > +               res_counter_return_resource(&mem->res, -1, NULL, 0);
> > > +       }
> > > +
> > 
> > Should we also re-account any remaining child usage to the parent?
> > 
> When this is called, there are no process in this group. Then, remaining
> resources in this level is
>   - file cache
>   - swap cache (if shared)
>   - shmem
> 
> And the biggest usage will be "file cache".
> So, I don't think it's necessary to move child's usage to the parent,
> in hurry. But maybe shmem is worth to be moved.
> 
> I'd like to revisit this when I implements "usage move at task move"
> logic. (currenty, memory usage doesn't move to new cgroup at task_attach.)
> 
> It will help me to implement the logic "move remaining usage to the parent"
> in clean way.
> 

I agree that "usage move at task move" is needed before
"move remaining usage to the parent".


Thanks,
Daisuke Nishimura.
