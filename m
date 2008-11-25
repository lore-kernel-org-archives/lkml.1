Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYKYNNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYKYNNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYKYNNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 08:13:07 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:34988 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYKYNNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 08:13:06 -0500
Date: Tue, 25 Nov 2008 14:13:03 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: muli@il.ibm.com, jdmason@kudzu.us, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] arch/x86/kernel/pci-calgary_64.c: change simple_strtol
 to simple_strtoul
Message-ID: <Pine.LNX.4.64.0811251412330.11897@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Since bridge is unsigned, it would seem better to use simple_strtoul that
simple_strtol.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r2@
long e;
position p;
@@

e = simple_strtol@p(...)

@@
position p != r2.p;
type T;
T e;
@@

e = 
- simple_strtol@p
+ simple_strtoul
  (...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

 arch/x86/kernel/pci-calgary_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1567,7 +1567,7 @@ static int __init calgary_parse_options(
 				++p;
 			if (*p == '\0')
 				break;
-			bridge = simple_strtol(p, &endp, 0);
+			bridge = simple_strtoul(p, &endp, 0);
 			if (p == endp)
 				break;
 
