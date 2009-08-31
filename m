Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbZHaMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbZHaMXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZHaMXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:23:18 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:41649 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZHaMXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:23:18 -0400
Date: Mon, 31 Aug 2009 17:53:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/5] memcg: uncharge in batched manner
Message-ID: <20090831122316.GM4770@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com> <20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com> <20090831110204.GG4770@balbir.in.ibm.com> <119e8331d1210b1f56d0f6416863bfbc.squirrel@webmail-b.css.fujitsu.com> <20090831121008.GL4770@balbir.in.ibm.com> <48d928bed22f20fc495e9ca1758dc7ed.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48d928bed22f20fc495e9ca1758dc7ed.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-31 21:14:10]:

> Balbir Singh wrote:
> >> > Does this effect deleting of a group and delay it by a large amount?
> >> >
> >> plz see what cgroup_release_and_xxxx  fixed. This is not for delay
> >> but for race-condition, which makes rmdir sleep permanently.
> >>
> >
> > I've seen those patches, where rmdir() can hang. My conern was time
> > elapsed since we do css_get() and do a cgroup_release_and_wake_rmdir()
> >
> plz read unmap() and truncate() code.
> The number of pages handled without cond_resched() is limited.
> 
>

I understand that part, I was referring to tasks stuck doing rmdir()
while we do batched uncharge, will it be very visible to the end user?
cond_resched() is bad in this case.. since it means we'll stay longer
before we release the cgroup.
 

-- 
	Balbir
