Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYISRCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYISRCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYISRBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:01:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbYISRBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:01:55 -0400
Message-ID: <48D3DAC5.9090308@linux-foundation.org>
Date: Fri, 19 Sep 2008 12:00:53 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080919145859.062069850@quilx.com> <20080919145929.158651064@quilx.com> <48D3D2EF.5090808@cosmosbay.com> <48D3D836.40306@linux-foundation.org>
In-Reply-To: <48D3D836.40306@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Completely wrong. We need this patch that Eric suggested:


Subject: cpu_alloc: Allow alignment < UNIT_SIZE

Limit the minimum alignment to UNIT_SIZE.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/mm/cpu_alloc.c
===================================================================
--- linux-2.6.orig/mm/cpu_alloc.c	2008-09-19 11:47:30.000000000 -0500
+++ linux-2.6/mm/cpu_alloc.c	2008-09-19 11:56:47.000000000 -0500
@@ -86,6 +86,9 @@

 	WARN_ON(align > PAGE_SIZE);

+	if (align < UNIT_SIZE)
+		align = UNIT_SIZE;
+
 	spin_lock_irqsave(&cpu_alloc_map_lock, flags);

 	first = 1
