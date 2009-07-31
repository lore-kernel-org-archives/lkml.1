Return-Path: <linux-kernel-owner+w=401wt.eu-S1751500AbZGaImK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbZGaImK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZGaImJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:42:09 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:51309 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbZGaImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:42:08 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907310842.n6V8g0vI006725@mercury.physics.adelaide.edu.au>
Subject: [PATCH 1/4] fujitsu-laptop: Correct redundant test
To: linux-acpi@vger.kernel.org
Date: Fri, 31 Jul 2009 18:12:00 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org, julia@diku.dk, bzolnier@gmail.com,
       kernel-janitors@vger.kernel.org
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
.. when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

--- a/drivers/platform/x86/fujitsu-laptop.c	2009-07-31 16:55:09.389775000 +0930
+++ b/drivers/platform/x86/fujitsu-laptop.c	2009-07-31 17:13:01.160777027 +0930
@@ -745,9 +745,6 @@ static int acpi_fujitsu_remove(struct ac
 
 	fujitsu = acpi_driver_data(device);
 
-	if (!device || !acpi_driver_data(device))
-		return -EINVAL;
-
 	fujitsu->acpi_handle = NULL;
 
 	return 0;
