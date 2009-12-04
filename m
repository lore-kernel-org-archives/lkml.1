Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZLDBDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZLDBDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 20:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbZLDBDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 20:03:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50804 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbZLDBDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 20:03:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Dec 2009 10:00:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       yanmin_zhang@linux.intel.com
Subject: Re: [RFC][mmotm][PATCH] percpu mm struct counter cache
Message-Id: <20091204100029.b703eaa0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262360912031649o42c9af52r35369fa820ec14f9@mail.gmail.com>
References: <20091203102851.daeb940c.kamezawa.hiroyu@jp.fujitsu.com>
	<4B17D506.7030701@gmail.com>
	<20091204091821.340ddcd5.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360912031649o42c9af52r35369fa820ec14f9@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009 09:49:17 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Fri, Dec 4, 2009 at 9:18 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Making read-side of this counter slower means making ps or top slower.
> > IMO, ps or top is too slow now and making them more slow is very bad.
> 
> Also, we don't want to make regression in no-split-ptl lock system.
> Now, tick update cost is zero in no-split-ptl-lock system.
yes.
> but task switching is a little increased since compare instruction.
Ah, 

+#ifdef USE_SPLIT_PTLOCKS
+extern void prepare_mm_switch(struct task_struct *prev,
+				 struct task_struct *next);
+#else
+static inline prepare_mm_switch(struct task_struct *prev,
+				struct task_struct *next)
+{
+}
+#endif

makes costs zero.

> As you know, task-switching is rather costly function.
yes.

> I mind additional overhead in so-split-ptl lock system.
yes. here. 
> I think we can remove the overhead completely.
> 

I have another version of this patch, which switches curr_mmc.mm
lazilu in a page fault. But it requires some complicated rules.
I'll try it again rather than adding hooks in context-switch.

BTW, I'm wondering to export "curr_mmc" to other files. Maybe
there will be some more information nice to be cached per cpu+mm.

Thanks,
-Kame

