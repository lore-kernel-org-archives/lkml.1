Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXJLHeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXJLHeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXJLHeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:34:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49634 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbXJLHeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:34:15 -0400
Date: Fri, 12 Oct 2007 16:36:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [BUGFIX][PATCH][ for -mm] bugfix for memory cgroup controller [2/5]
 fix error handling path in mem_charge_cgroup
Message-Id: <20071012163615.528b563d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This unlock_page_cgroup() is unnecessary.

Changelog: v1 -> v2
 * adjusted to 2.6.23-mm1

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

Index: devel-2.6.23-mm1/mm/memcontrol.c
===================================================================
--- devel-2.6.23-mm1.orig/mm/memcontrol.c
+++ devel-2.6.23-mm1/mm/memcontrol.c
@@ -392,9 +392,7 @@ done:
 	return 0;
 free_pc:
 	kfree(pc);
-	return -ENOMEM;
 err:
-	unlock_page_cgroup(page);
 	return -ENOMEM;
 }
 

