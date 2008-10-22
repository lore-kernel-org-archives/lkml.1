Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYJVDje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYJVDje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJVDj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:39:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58786 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbYJVDjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:39:25 -0400
Message-ID: <48FEA019.10606@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 11:38:01 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Breaks the redundant loop in kernel/marker.c
References: <48FC273B.3030300@cn.fujitsu.com> <20081020065205.GA12927@elte.hu> <48FC3083.8020104@cn.fujitsu.com> <20081020072520.GE12131@elte.hu> <20081020153850.GB27993@Krystal>
In-Reply-To: <20081020153850.GB27993@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because e->name is unique in list, we don't need to continue the iteration
after matched.

Impact: cleanup, no functionality changed

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/marker.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/marker.c b/kernel/marker.c
index e9c6b2b..8b5d253 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -848,8 +848,6 @@ void *marker_get_private_data(const char *name, marker_probe_func *probe,
 			if (!e->ptype) {
 				if (num == 0 && e->single.func == probe)
 					return e->single.probe_private;
-				else
-					break;
 			} else {
 				struct marker_probe_closure *closure;
 				int match = 0;
@@ -861,6 +859,7 @@ void *marker_get_private_data(const char *name, marker_probe_func *probe,
 						return closure[i].probe_private;
 				}
 			}
+			break;
 		}
 	}
 	return ERR_PTR(-ENOENT);
-- 
1.5.5.3



