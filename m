Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZAOGNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZAOGNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZAOGNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:13:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46854 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZAOGNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:13:12 -0500
Date: Thu, 15 Jan 2009 15:12:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 1/4] cgroup: support per cgroup subsys state ID
 (CSS ID)
Message-Id: <20090115151203.e79271c0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090112072147.GB27129@balbir.in.ibm.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108182817.2c393351.kamezawa.hiroyu@jp.fujitsu.com>
	<20090112072147.GB27129@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delayed reply.


On Mon, 12 Jan 2009 12:51:48 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-08 18:28:17]:
> > There are several reasons to develop this.
> > 	- Saving space .... For example, memcg's swap_cgroup is array of
> > 	  pointers to cgroup. But it is not necessary to be very fast.
> > 	  By replacing pointers(8bytes per ent) to ID (2byes per ent), we can
> > 	  reduce much amount of memory usage.
> 
> 2 bytes per entry means that we restrict the entries to 2^16-1 for
> number of cgroups, using a pointer introduces no such restriction.
> 2^16-1 seems a reasonable number for now.
> 
yes.


> >  /* bits in struct cgroup_subsys_state flags field */
> > @@ -363,6 +367,11 @@ struct cgroup_subsys {
> >  	int active;
> >  	int disabled;
> >  	int early_init;
> > +	/*
> > +	 * True if this subsys uses ID. ID is not available before cgroup_init()
> > +	 * (not available in early_init time.)
>                                             ^ period should come later
sure.

;
> > +	/*
> > +	 * Hierarchy of CSS ID belongs to.
> > +	 */
> > +	unsigned short  stack[0]; /* Array of Length (depth+1) */
> 
> By maintaining the path up to the root here, is that how we avoid walking
> through cgroups links?
> 
yes. we can check this css is under hierarchy by

   css->stack[root->depth] == root->id.


> > +/**
> >   * idr_replace - replace pointer for given id
> >   * @idp: idr handle
> >   * @ptr: pointer you want associated with the id
> >
> 
> Overall, I've taken a quick look and the patches seem OK.
> 
thx,

-Kame

