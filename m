Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYJTHSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYJTHSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYJTHSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:18:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYJTHSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:18:45 -0400
Message-ID: <48FC3083.8020104@cn.fujitsu.com>
Date: Mon, 20 Oct 2008 15:17:23 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] Breaks the redundant loop in kernel/marker.c
References: <48FC273B.3030300@cn.fujitsu.com> <20081020065205.GA12927@elte.hu>
In-Reply-To: <20081020065205.GA12927@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, could you describe the necessity of this patch some more? This has 
> the change to change behavior, which might even be a bugfix: is there 
> any chance that the closure-loop in the e->ptype != NULL branch does not 
> exit? Before your patch we'd continue the iteration - which _probably_ 
> does not lead to any more matches (e->name is supposed to be unique).

Because e->name is unique in list, we don't need to continue the iteration
after matched.
This is a cleanup.

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


