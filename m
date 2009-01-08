Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZAHElV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZAHElV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZAHElM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:41:12 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:42361 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZAHElL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:41:11 -0500
Date: Thu, 8 Jan 2009 10:11:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC][PATCH 3/4] Memory controller soft limit organize cgroups
Message-ID: <20090108044108.GG7294@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain> <20090107184128.18062.96016.sendpatchset@localhost.localdomain> <20090108101148.96e688f4.kamezawa.hiroyu@jp.fujitsu.com> <20090108042558.GC7294@balbir.in.ibm.com> <20090108132855.77d3d3d4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090108132855.77d3d3d4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-08 13:28:55]:

> On Thu, 8 Jan 2009 09:55:58 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-08 10:11:48]:
> > > Hmm,  Could you clarify following ?
> > >   
> > >   - Usage of memory at insertsion and usage of memory at reclaim is different.
> > >     So, this *sorted* order by RB-tree isn't the best order in general.
> > 
> > True, but we frequently update the tree at an interval of HZ/4.
> > Updating at every page fault sounded like an overkill and building the
> > entire tree at reclaim is an overkill too.
> > 
> "sort" is not necessary.
> If this feature is implemented as background daemon,
> just select the worst one at each iteration is enough.

OK, definitely an alternative worth considering, but the trade-off is
lazy building (your suggestion), which involves actively seeing the
usage of all cgroups (and if they are large, O(c), c is number of
cgroups can be quite a bit) versus building the tree as and when the
fault occurs and controlled by some interval.

-- 
	Balbir
