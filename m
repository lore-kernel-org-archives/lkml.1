Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZFBTt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZFBTt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZFBTtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:49:20 -0400
Received: from kroah.org ([198.145.64.141]:40396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZFBTtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:49:19 -0400
Subject: patch staging-rtlxxxx-off-by-one-in-asicsendcommandtomcu-and-ndis_status-nicloadfirmware.patch added to gregkh-2.6 tree
To: roel.kluin@gmail.com, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Tue, 02 Jun 2009 12:43:06 -0700
In-Reply-To: <4A0B1382.6040501@gmail.com>
Message-ID: <12439717863001@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: rtlxxxx: off by one in AsicSendCommandToMcu() and NDIS_STATUS NICLoadFirmware()

to my gregkh-2.6 tree.  Its filename is

    staging-rtlxxxx-off-by-one-in-asicsendcommandtomcu-and-ndis_status-nicloadfirmware.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From roel.kluin@gmail.com  Tue Jun  2 12:06:10 2009
From: Roel Kluin <roel.kluin@gmail.com>
Date: Wed, 13 May 2009 20:37:54 +0200
Subject: staging: rtlxxxx: off by one in AsicSendCommandToMcu() and NDIS_STATUS NICLoadFirmware()
To: Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <4A0B1382.6040501@gmail.com>


With a postfix increment i/Index is incremented beyond 100/1000 so the
message will be displayed too soon.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/common/mlme.c      |    2 +-
 drivers/staging/rt2860/common/rtmp_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -7866,7 +7866,7 @@ BOOLEAN AsicSendCommandToMcu(
 		RTMPusecDelay(2);
 	} while(i++ < 100);
 
-	if (i >= 100)
+	if (i > 100)
 	{
 		{
 #ifdef RT2860
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -3366,7 +3366,7 @@ NDIS_STATUS NICLoadFirmware(
 		RTMPusecDelay(1000);
 	} while (Index++ < 1000);
 
-    if (Index >= 1000)
+    if (Index > 1000)
 	{
 		Status = NDIS_STATUS_FAILURE;
 		DBGPRINT(RT_DEBUG_ERROR, ("NICLoadFirmware: MCU is not ready\n\n\n"));

