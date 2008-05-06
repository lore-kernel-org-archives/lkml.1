Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbYEFHCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbYEFHCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYEFHCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:02:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52413 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYEFHCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:02:23 -0400
Date: Tue, 06 May 2008 16:02:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: make vmstat cpu-unplug safe
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080506154938.AC6B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw: I think all_vm_event() author is Cristoph Lameter, right?


--------------------------------------------
When access cpu_online_map, We should prevent that dynamically 
change cpu_online_map by get_online_cpus().

Unfortunately, all_vm_events() doesn't it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Christoph Lameter <clameter@sgi.com>

---
 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c       2008-05-04 23:00:52.000000000 +0900
+++ b/mm/vmstat.c       2008-05-06 16:13:32.000000000 +0900
@@ -42,7 +42,9 @@ static void sum_vm_events(unsigned long
 */
 void all_vm_events(unsigned long *ret)
 {
+       get_online_cpus();
        sum_vm_events(ret, &cpu_online_map);
+       put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(all_vm_events);



