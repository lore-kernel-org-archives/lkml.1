Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYHGMWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYHGMWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYHGMWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:22:02 -0400
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:34498 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYHGMV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:21:58 -0400
Date: Thu, 07 Aug 2008 20:00:37 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: Race condition between putback_lru_page and mem_cgroup_move_list
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       MinChan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1218041585.6173.45.camel@lts-notebook>
References: <489741F8.2080104@linux.vnet.ibm.com> <1218041585.6173.45.camel@lts-notebook>
Message-Id: <20080807185203.A8C2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> If you mean the "active/inactive list transition" in
> shrink_[in]active_list(), these are already batched under zone lru_lock
> with batch size determined by the 'release pages' pvec.  So, I think
> we're OK here.

No.

AFAIK shrink_inactive_list batched zone->lru_lock, 
but it doesn't batched mz->lru_lock.

then, spin_lock_irqsave is freqently called.



