Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056Ab0AAT4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0AAT4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 14:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944Ab0AAT4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 14:56:06 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:53544 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0AAT4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 14:56:05 -0500
From: David John <davidjon@xenontk.org>
To: jbarnes@virtuousgeek.org, rusty@rustcorp.com.au
Cc: andreas.herrmann3@amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Check the node argument passed to cpumask_of_node
Date: Sat,  2 Jan 2010 01:25:02 +0530
Message-Id: <1262375702-5366-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: BlackWidow
In-Reply-To: <4B3E51FC.9000502@xenontk.org>
References: <4B3E51FC.9000502@xenontk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the node value is valid.

Signed-off-by: David John <davidjon@xenontk.org>

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index c5087d7..1141a6e 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -99,7 +99,8 @@ extern const struct cpumask *cpumask_of_node(int node);
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
 static inline const struct cpumask *cpumask_of_node(int node)
 {
-	return node_to_cpumask_map[node];
+	return (node < 0 || node >= nr_node_ids) ? cpu_online_mask :
+						   node_to_cpumask_map[node];
 }
 #endif
 
