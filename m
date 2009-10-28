Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbZJ1HcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbZJ1HcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932618AbZJ1HcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:32:14 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56709 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbZJ1HcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:32:13 -0400
Date: Wed, 28 Oct 2009 13:02:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: make memcg's file mapped consistent with global
 VM
Message-ID: <20091028073212.GO16378@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091028121619.c094e9c0.kamezawa.hiroyu@jp.fujitsu.com>
 <20091028071854.GL16378@balbir.in.ibm.com>
 <20091028162458.45865281.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091028162458.45865281.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-10-28 16:24:58]:

> On Wed, 28 Oct 2009 12:48:54 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-10-28 12:16:19]:
> > 
> > > Based on mmotm-Oct13 + some patches in -mm queue.
> > > 
> > > ==
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > memcg-cleanup-file-mapped-consistent-with-globarl-vm-stat.patch
> > > 
> > > In global VM, FILE_MAPPED is used but memcg uses MAPPED_FILE.
> > > This makes grep difficult. Replace memcg's MAPPED_FILE with FILE_MAPPED
> > > 
> > > And in global VM, mapped shared memory is accounted into FILE_MAPPED.
> > > But memcg doesn't. fix it.
> > 
> > I wanted to explicitly avoid this since I wanted to do an iterative
> > correct accounting of shared memory. The renaming is fine with me
> > since we don't break ABI in user space.
> > 
> To do that, FILE_MAPPED is not correct.
> Because MAPPED includes shmem in global VM, no valid reason to do different
> style of counting.

OK, fair enough! Lets count shmem in FILE_MAPPED

> 
> For shmem, we have a charge type as MEM_CGROUP_CHARGE_TYPE_SHMEM and 
> we can set "PCG_SHMEM" flag onto page_cgroup or some.
> Then, we can count it in explicit way. 
>

Apart from shmem, I want to count all memory that is shared (mapcount > 1),
I'll send out an RFC once I have the implementation. For now, I
want to focus on testing memcg a bit more and start looking at some
aspects of dirty accounting.

-- 
	Balbir
