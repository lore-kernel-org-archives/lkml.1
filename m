Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYBNPOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYBNPOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYBNPOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:14:09 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:46448 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbYBNPOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:14:07 -0500
Date: Thu, 14 Feb 2008 16:14:04 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: jeremy@xensource.com, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/6] arch/x86/xen: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.58.0802141613300.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c 2008-02-02 15:28:17.000000000 +0100
+++ b/arch/x86/xen/enlighten.c 2008-02-13 20:48:15.000000000 +0100
@@ -293,7 +293,7 @@ static void xen_load_gdt(const struct de
 	unsigned long *frames;
 	unsigned long va = dtr->address;
 	unsigned int size = dtr->size + 1;
-	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+	unsigned pages = DIV_ROUND_UP(size, PAGE_SIZE);
 	int f;
 	struct multicall_space mcs;

