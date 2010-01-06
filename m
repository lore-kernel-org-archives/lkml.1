Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759Ab0AFDH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0AFDH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 22:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862Ab0AFDH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 22:07:58 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49323 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0AFDH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 22:07:58 -0500
Date: Wed, 6 Jan 2010 08:37:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Shared Page accounting for memory cgroup (v2)
Message-ID: <20100106030752.GI3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100105185226.GG3059@balbir.in.ibm.com>
 <20100106090708.f3ec9fd8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100106090708.f3ec9fd8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 09:07:08]:

> On Wed, 6 Jan 2010 00:22:26 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Hi, All,
> > 
> > No major changes from v1, except for the use of get_mm_rss().
> > Kamezawa-San felt that this can be done in user space and I responded
> > to him with my concerns of doing it in user space. The thread
> > can be found at http://thread.gmane.org/gmane.linux.kernel.mm/42367.
> > 
> > If there are no major objections, can I ask for a merge into -mm.
> > Andrew, the patches are against mmotm 10 December 2009, if there
> > are some merge conflicts, please let me know, I can rebase after
> > you release the next mmotm.
> > 
> 
> The problem is that this isn't "shared" uasge but "considered to be shared"
> usage. Okay ?
>

Could you give me your definition of "shared". From the mem cgroup
perspective, total_rss (which is accumulated) subtracted from the
count of pages in the LRU which are RSS and FILE_MAPPED is shared, no?
I understand that some of the pages that might be shared, show up
in our LRU and accounting. These are not treated as shared by
our cgroup, but by other cgroups.
 
> Then I don't want to provide this misleading value as "official report" from
> the kernel. And this can be done in userland.
>

I explained some of the issues of doing this from user space, would
you be OK if I called them "non-private" pages?

-- 
	Balbir
