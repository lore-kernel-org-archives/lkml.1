Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYF2NAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYF2NAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYF2M77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:59:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49166 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbYF2M76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:59:58 -0400
Date: Sun, 29 Jun 2008 21:58:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] splitlru: memcg swapbacked pages active
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806291302160.787@blonde.site>
References: <20080629171251.37CA.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0806291302160.787@blonde.site>
Message-Id: <20080629213352.37D5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But it seems to me worrying and fragile while they diverge in this way.
> If the global has anon, active anon, file, active file and unevictable
> lrus for the page; and the memcg has anon, active anon, file, active file
> and unevictable lrus for the page cgroup; but different choices are made
> which to put on where, then we're heading for confusion and trouble.
>
> And when called, __mem_cgroup_move_lists tries to keep the activ-ity of
> the memcg lrus in step with the activ-ity of the global lrus, doesn't
> it?  So it's beyond my comprehension to start them off out of step.

Well...
you are right.

Hmm.. OK, I propse alternative way.

step1: commit this patch
step2: implement active/inactive anon balancing routine

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thank you for good patch.


btw, furtunately, memcg reclaim has some retry.
thus, lru imbalancing doesn't cause OOM, it only cause small performance degression.
IMHO your patch doesn't have any risk.



