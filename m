Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZG0QTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZG0QTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZG0QTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:19:33 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:49184 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbZG0QTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:19:31 -0400
Date: Mon, 27 Jul 2009 18:14:11 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jwoithe@physics.adelaide.edu.au, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/12] drivers/platform/x86: Correct redundant test
Message-ID: <Pine.LNX.4.64.0907271813490.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

device and acpi_driver_data(device) were tested just a few lines above.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
@@

if (x == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/platform/x86/fujitsu-laptop.c          |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 218b9a1..5306901 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -745,9 +745,6 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 
 	fujitsu = acpi_driver_data(device);
 
-	if (!device || !acpi_driver_data(device))
-		return -EINVAL;
-
 	fujitsu->acpi_handle = NULL;
 
 	return 0;
