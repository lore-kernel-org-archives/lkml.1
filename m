Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYGCOle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYGCOle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYGCOl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:41:26 -0400
Received: from mail.ccur.com ([12.192.68.12]:30140 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbYGCOlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:41:25 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 10:41:24 EDT
Message-ID: <486CE3CD.7090907@ccur.com>
Date: Thu, 3 Jul 2008 10:35:57 -0400
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Todd Allen <todd.allen@ccur.com>
Subject: [PATCH] node meminfo Active & Inactive pages to Kbytes
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Andi,

We found a minor bug in the output of
/sys/devices/system/node/node[n]/meminfo
where the Active and Inactive values are in pages instead of Kbytes.

Looks like this occurred back in 2.6.20 when the code was changed
over to use node_page_state().

Thanks.

--- linux.2.6.26-rc8/drivers/base/node.c	2008-07-03 09:26:01.000000000 -0400
+++ new/drivers/base/node.c	2008-07-03 09:25:45.000000000 -0400
@@ -84,8 +84,8 @@ static ssize_t node_read_meminfo(struct
  		       nid, K(i.totalram),
  		       nid, K(i.freeram),
  		       nid, K(i.totalram - i.freeram),
-		       nid, node_page_state(nid, NR_ACTIVE),
-		       nid, node_page_state(nid, NR_INACTIVE),
+		       nid, K(node_page_state(nid, NR_ACTIVE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE)),
  #ifdef CONFIG_HIGHMEM
  		       nid, K(i.totalhigh),
  		       nid, K(i.freehigh),
