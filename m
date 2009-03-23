Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZCWBUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZCWBUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 21:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZCWBUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 21:20:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43440 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZCWBUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 21:20:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] fix vmscan to take care of nodemask
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mel@csn.ul.ie,
       riel@redhat.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20090323101348.07b9c761.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090323100356.e980d266.kamezawa.hiroyu@jp.fujitsu.com> <20090323101348.07b9c761.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090323101632.69E7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Mar 2009 10:20:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Kosaki pointed out it's not necessary to initialize struct member value by NULL.
> Remvoed it. 
> 
> Regards,
> -Kame
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> try_to_free_pages() scans zonelist but don't take care of nodemask which is
> given to alloc_pages_nodemask(). This makes try_to_free_pages() less effective.

Yes, ignore nodemask make unnecessary reclaim. it decrease try_to_free_pages()
performance.

Note: currently, try_to_free_pages() stop to process reclaim after 32 pages reclaimed.
then, non intentional node scanning can cause large performance degression.

> 
> Changelog: v1 -> v2
>   - removed unnecessary nodemask=NULL initialization.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

thanks.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



