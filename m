Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZGPEWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZGPEWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZGPEWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:22:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45957 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZGPEWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:22:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090715201654.550cb640.akpm@linux-foundation.org>
References: <20090716095119.9D0A.A69D9226@jp.fujitsu.com> <20090715201654.550cb640.akpm@linux-foundation.org>
Message-Id: <20090716131928.9D25.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 13:22:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 16 Jul 2009 09:52:34 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> >  	if (file)
> > -		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
> > +		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
> >  	else
> > -		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
> > +		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);
> 
> we could have used __sub_zone_page_state() there.

__add_zone_page_state() and __sub_zone_page_state() are no user.

Instead, we can remove it?


==============================================
Subject: Kill __{add,sub}_zone_page_state()

Currently, __add_zone_page_state() and __sub_zone_page_state() are unused.
This patch remove it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/vmstat.h |    5 -----
 1 file changed, 5 deletions(-)

Index: b/include/linux/vmstat.h
===================================================================
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -210,11 +210,6 @@ extern void zone_statistics(struct zone 
 
 #endif /* CONFIG_NUMA */
 
-#define __add_zone_page_state(__z, __i, __d)	\
-		__mod_zone_page_state(__z, __i, __d)
-#define __sub_zone_page_state(__z, __i, __d)	\
-		__mod_zone_page_state(__z, __i,-(__d))
-
 #define add_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, __d)
 #define sub_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, -(__d))
 




