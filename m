Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbYJTGjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbYJTGjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 02:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYJTGjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 02:39:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60332 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYJTGjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 02:39:08 -0400
Message-ID: <48FC273B.3030300@cn.fujitsu.com>
Date: Mon, 20 Oct 2008 14:37:47 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Breaks the redundant loop in kernel/marker.c
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/marker.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/marker.c b/kernel/marker.c
index 7d1faec..2c3172d 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -836,8 +836,6 @@ void *marker_get_private_data(const char *name, marker_probe_func *probe,
 			if (!e->ptype) {
 				if (num == 0 && e->single.func == probe)
 					return e->single.probe_private;
-				else
-					break;
 			} else {
 				struct marker_probe_closure *closure;
 				int match = 0;
@@ -849,6 +847,7 @@ void *marker_get_private_data(const char *name, marker_probe_func *probe,
 						return closure[i].probe_private;
 				}
 			}
+			break;
 		}
 	}
 	return ERR_PTR(-ENOENT);
-- 
1.5.5.3


