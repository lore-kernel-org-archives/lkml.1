Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbZLPQMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbZLPQMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934942AbZLPQLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:11:48 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40804 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934911AbZLPQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:11:45 -0500
Date: Wed, 16 Dec 2009 10:10:30 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 7/8] Module handling: Use this_cpu_xx to
 dynamically allocate counters
In-Reply-To: <200912160911.43201.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0912160900470.8572@router.home>
References: <20091214220320.665065925@quilx.com> <20091214220342.473600725@quilx.com> <4B270AA6.3050307@kernel.org> <200912160911.43201.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup patch:

Subject: Extend preempt_disable section around module_is_live()

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/module.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h	2009-12-16 08:57:37.000000000 -0600
+++ linux-2.6/include/linux/module.h	2009-12-16 08:58:09.000000000 -0600
@@ -467,15 +467,17 @@ static inline int try_module_get(struct
 	int ret = 1;

 	if (module) {
+		preempt_disable();
+
 		if (likely(module_is_live(module))) {
-			preempt_disable();
 			__this_cpu_inc(module->refptr->count);
 			trace_module_get(module, _THIS_IP_,
 				__this_cpu_read(module->refptr->count));
-			preempt_enable();
 		}
 		else
 			ret = 0;
+
+		preempt_enable();
 	}
 	return ret;
 }
