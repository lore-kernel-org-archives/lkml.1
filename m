Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbZFPMI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbZFPMI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZFPMIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:08:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38356 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884AbZFPMIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:08:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring behaviour more in line with expectations V3
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       fengguang.wu@intel.com, linuxram@us.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20090615152543.GF23198@csn.ul.ie>
References: <alpine.DEB.1.10.0906151057270.23995@gentwo.org> <20090615152543.GF23198@csn.ul.ie>
Message-Id: <20090616202210.99B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Jun 2009 21:08:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jun 15, 2009 at 11:01:41AM -0400, Christoph Lameter wrote:
> > On Mon, 15 Jun 2009, Mel Gorman wrote:
> > 
> > > > May I ask your worry?
> > > >
> > >
> > > Simply that I believe the intention of PF_SWAPWRITE here was to allow
> > > zone_reclaim() to aggressively reclaim memory if the reclaim_mode allowed
> > > it as it was a statement that off-node accesses are really not desired.
> > 
> > Right.
> > 
> > > Ok. I am not fully convinced but I'll not block it either if believe it's
> > > necessary. My current understanding is that this patch only makes a difference
> > > if the server is IO congested in which case the system is struggling anyway
> > > and an off-node access is going to be relatively small penalty overall.
> > > Conceivably, having PF_SWAPWRITE set makes things worse in that situation
> > > and the patch makes some sense.
> > 
> > We could drop support for RECLAIM_SWAP if that simplifies things.
> > 
> 
> I don't think that is necessary. While I expect it's very rarely used, I
> imagine a situation where it would be desirable on a system that had large
> amounts of tmpfs pages but where it wasn't critical they remain in-memory.
> 
> Removing PF_SWAPWRITE would make it less aggressive and if you were
> happy with that, then that would be good enough for me.

I surprised this a bit. I've imazined Christoph never agree to remove it.
Currently, trouble hitting user of mine don't use this feature. Thus, if it can be
removed, I don't need to worry abusing this again and I'm happy.

Mel, Have you seen actual user of this?



