Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYISUdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYISUdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYISUdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:33:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409AbYISUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:33:00 -0400
Message-ID: <48D40C43.5070200@linux-foundation.org>
Date: Fri, 19 Sep 2008 15:32:03 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       ebiederm@xmission.com, travis@sgi.com, herbert@gondor.apana.org.au,
       xemul@openvz.org, penberg@cs.helsinki.fi
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080919145859.062069850@quilx.com> <20080919145929.158651064@quilx.com>
In-Reply-To: <20080919145929.158651064@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duh. A cast went missing which results in a pointer calculation going haywire.

Signed-off-by: <cl@linux-foundation.org>

Index: linux-2.6/mm/cpu_alloc.c
===================================================================
--- linux-2.6.orig/mm/cpu_alloc.c	2008-09-19 14:57:25.000000000 -0500
+++ linux-2.6/mm/cpu_alloc.c	2008-09-19 14:57:33.000000000 -0500
@@ -126,7 +126,7 @@

 	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);

-	ptr = __per_cpu_end + start;
+	ptr = (int *)__per_cpu_end + start;

 	printk(KERN_INFO "%d per cpu units allocated at offset %lx address %p\n",
 		units, start, ptr)

