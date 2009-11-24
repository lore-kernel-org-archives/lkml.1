Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbZKXPHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbZKXPHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbZKXPHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:48 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39132 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933247AbZKXPHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:46 -0500
Message-Id: <20091124150752.037140000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:05 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 08/29] GRU - fix bug in module unload
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_rmmod_fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix bug in module unload. Previous code was not correctly
deleting the files in /proc.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/gruprocfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2009-11-20 09:32:29.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2009-11-20 09:32:30.000000000 -0600
@@ -351,7 +351,7 @@ static void delete_proc_files(void)
 		for (p = proc_files; p->name; p++)
 			if (p->entry)
 				remove_proc_entry(p->name, proc_gru);
-		remove_proc_entry("gru", NULL);
+		remove_proc_entry("gru", proc_gru->parent);
 	}
 }
 

