Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYFWBss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYFWBss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 21:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYFWBsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 21:48:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47510 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYFWBsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 21:48:40 -0400
Date: Mon, 23 Jun 2008 10:49:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Subject: Re: [patch] memory reclaim more  efficiently
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Keiichi KII <kii@linux.bs1.fc.nec.co.jp>
In-Reply-To: <485EF481.30409@ah.jp.nec.com>
References: <485EF481.30409@ah.jp.nec.com>
Message-Id: <20080623102854.37BE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi nagano-san,

> In shrink_zone(), system can not return to user mode before it finishes to
> search LRU list. IMHO, it is very wasteful, since the user processes stay
> unnecessarily long time in shrink_zone() loop and application response time
> becomes relatively bad. This patch changes shrink_zone() that it finishes memory
> reclaim when it reclaims enough memory.
> 
> the conditions to end searching:
> 
> 1. order of request page is 0
> 2. process is not kswapd.
> 3. satisfy the condition to return try_to_free_pages()
>    # nr_reclaim > SWAP_CLUSTER_MAX

I have 3 question.

1. Do you have any performance number?
2. I think this patch advocate many try_to_free_pages() called is better than
   one try_to_free_page waste long time. right?
   and, why do you think so?
3. if this patch improve perfomance, I guess DEF_PRIORITY is
   too small on your machine.
   if DEF_PRIORITY is proportional to system memory, do your problem are solved?



