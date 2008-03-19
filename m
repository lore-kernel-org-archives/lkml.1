Return-Path: <linux-kernel-owner+w=401wt.eu-S941020AbYCSWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941020AbYCSWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935972AbYCSVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:03:16 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:25008 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935969AbYCSVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=GKEurRsDLnzSyhCwg6htAwrv6DUpIpjrNBfEm3zaYKEG7UP9SSiyk5XsxlZb6j1P0sLPvZqceOk57AdvjcmJQdjyM8P2rZc4HA4scjw4kNPn1Won9VqMTMjyGPudUVUGSeg3Fg2Q7jTFhNkz04vq2gqDHSm+aEQC18V2/0nXkag=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 03/12] x86_64: free_bootmem should take phys
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1574
Date: Wed, 19 Mar 2008 14:03:47 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191403.47316.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: free_bootmem should take phys

so use nodedata_phys directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -221,8 +221,7 @@ void __init setup_node_bootmem(int nodei
 				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
 	if (bootmap == NULL)  {
 		if (nodedata_phys < start || nodedata_phys >= end)
-			free_bootmem((unsigned long)node_data[nodeid],
-				     pgdat_size);
+			free_bootmem(nodedata_phys, pgdat_size);
 		node_data[nodeid] = NULL;
 		return;
 	}
