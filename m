Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZAHEaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZAHEaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZAHEaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:30:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46422 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZAHEaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:30:00 -0500
Date: Thu, 8 Jan 2009 13:28:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC][PATCH 3/4] Memory controller soft limit organize cgroups
Message-Id: <20090108132855.77d3d3d4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090108042558.GC7294@balbir.in.ibm.com>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
	<20090107184128.18062.96016.sendpatchset@localhost.localdomain>
	<20090108101148.96e688f4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108042558.GC7294@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 09:55:58 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-08 10:11:48]:
> > Hmm,  Could you clarify following ?
> >   
> >   - Usage of memory at insertsion and usage of memory at reclaim is different.
> >     So, this *sorted* order by RB-tree isn't the best order in general.
> 
> True, but we frequently update the tree at an interval of HZ/4.
> Updating at every page fault sounded like an overkill and building the
> entire tree at reclaim is an overkill too.
> 
"sort" is not necessary.
If this feature is implemented as background daemon,
just select the worst one at each iteration is enough.


> >     Why don't you sort this at memory-reclaim dynamically ?
> >   - Considering above, the look of RB tree can be
> > 
> >                 +30M (an amount over soft limit is 30M)
> >                 /  \
> >              -15M   +60M
> 
> We don't have elements below their soft limit in the tree
> 
> >      ?
> > 
> >     At least, pleease remove the node at uncharge() when the usage goes down.
> >
> 
> We do remove the tree if it goes under its soft limit at commit_charge,
> I thought I had the same code in uncharge(), but clearly that is
> missing. Thanks, I'll add it there.
> 

Ah, ok. I missed it. Thank you for clalification.

Regards,
-Kame

