Return-Path: <linux-kernel-owner+w=401wt.eu-S966336AbYCTAnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966336AbYCTAnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965018AbYCTAkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:40:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48682 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017AbYCTAk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:40:29 -0400
Message-Id: <20080320002737.918213455@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 19 Mar 2008 20:27:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] Markers updates for 2.6.25-rc6
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 20 Mar 2008 00:28:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are a few updates for the kernel markers. One is particularity important :
the combined use of preempt_disable/enable() and call_rcu/rcu_barrier does not
mix well with PREEMPT_RCU. I added a depends !PREEMPT_RCU to the markers to this
configuration is not reached.

The proper fix will imply to implement call_sched and sched_barrier, but I don't
think it will appear before 2.6.25.

It applies on top of 2.6.25-rc6 on top of the make-marker_debug-static.patch
already in your tree in th following order :

markers-depends-on-not-preempt-rcu.patch
markers-add-comments.patch
markers-remove-access-once.patch
markers-support-for-proprietary-modules.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
