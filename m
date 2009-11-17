Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZKQHWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZKQHWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZKQHW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:22:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58693 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbZKQHW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:22:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] cifs: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Message-Id: <20091117162111.3DE8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 16:22:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
memory, anyone must not prevent it. Otherwise the system cause
mysterious hang-up and/or OOM Killer invokation.

Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs-client@lists.samba.org
Cc: samba-technical@lists.samba.org
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/cifs/connect.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 63ea83f..f9b1553 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -337,7 +337,6 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	bool isMultiRsp;
 	int reconnect;
 
-	current->flags |= PF_MEMALLOC;
 	cFYI(1, ("Demultiplex PID: %d", task_pid_nr(current)));
 
 	length = atomic_inc_return(&tcpSesAllocCount);
-- 
1.6.2.5



