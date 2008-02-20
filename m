Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYBTMXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYBTMXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYBTMXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:23:42 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:39346 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYBTMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:23:41 -0500
Date: Wed, 20 Feb 2008 13:23:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, balbir@linux.vnet.ibm.com
Subject: [PATCH] Document huge memory/cache overhead of memory controller in Kconfig
Message-ID: <20080220122338.GA4352@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Feb 2008 12:17:14.0143 (UTC) FILETIME=[86B8D2F0:01C873BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document huge memory/cache overhead of memory controller in Kconfig

I was a little surprised that 2.6.25-rc* increased struct page for the memory
controller.  At least on many x86-64 machines it will not fit into a single
cache line now anymore and also costs considerable amounts of RAM. 
At earlier review I remembered asking for a external data structure for this.

It's also quite unobvious that a innocent looking Kconfig option with a 
single line Kconfig description has such a negative effect.

This patch attempts to document these disadvantages at least so that users
configuring their kernel can make a informed decision.

Cc: balbir@linux.vnet.ibm.com

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig
+++ linux/init/Kconfig
@@ -394,6 +394,14 @@ config CGROUP_MEM_CONT
 	  Provides a memory controller that manages both page cache and
 	  RSS memory.
 
+	  Note that setting this option increases fixed memory overhead
+	  associated with each page of memory in the system by 4/8 bytes
+	  and also increases cache misses because struct page on many 64bit
+	  systems will not fit into a single cache line anymore.
+
+	  Only enable when you're ok with these trade offs and really
+	  sure you need the memory controller.
+
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
