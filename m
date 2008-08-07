Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbYHGMVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbYHGMVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYHGMV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:21:27 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11890 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYHGMVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:21:23 -0400
Subject: Re: Race condition between putback_lru_page and
	mem_cgroup_move_list
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, MinChan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080807185203.A8C2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <489741F8.2080104@linux.vnet.ibm.com>
	 <1218041585.6173.45.camel@lts-notebook>
	 <20080807185203.A8C2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 07:27:14 -0400
Message-Id: <1218108434.6086.29.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 20:00 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > If you mean the "active/inactive list transition" in
> > shrink_[in]active_list(), these are already batched under zone lru_lock
> > with batch size determined by the 'release pages' pvec.  So, I think
> > we're OK here.
> 
> No.
> 
> AFAIK shrink_inactive_list batched zone->lru_lock, 
> but it doesn't batched mz->lru_lock.
> 
> then, spin_lock_irqsave is freqently called.

Ah, I see what you mean.  Yes, the mem cgroup zone lru_lock will be
cycled frequently as each back of pages is put back during reclaim.  So,
you'd like to eliminate the mz lru_lock, move the mem cgroup zone info
under the corresponding zone lru_lock and move the page between memcg
lists atomically with adding to global lru lists?  

Lee

