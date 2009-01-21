Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZAUSK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZAUSK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbZAUSJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:09:16 -0500
Received: from kroah.org ([198.145.64.141]:58556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754728AbZAUSJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:09:14 -0500
Subject: patch staging-meilhaus-unsigned-won-t-get-negative-after-subtraction.patch added to gregkh-2.6 tree
To: roel.kluin@gmail.com, g.gebhardt@meilhaus.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org, mail@davidkiliani.de
From: <gregkh@suse.de>
Date: Wed, 21 Jan 2009 10:07:04 -0800
In-Reply-To: <49733E0F.7030305@gmail.com>
Message-ID: <12325612242414@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: meilhaus: unsigned won't get negative after subtraction

to my gregkh-2.6 tree.  Its filename is

    staging-meilhaus-unsigned-won-t-get-negative-after-subtraction.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From roel.kluin@gmail.com  Wed Jan 21 09:47:26 2009
From: Roel Kluin <roel.kluin@gmail.com>
Date: Sun, 18 Jan 2009 15:34:55 +0100
Subject: Staging: meilhaus: unsigned won't get negative after subtraction
To: <mail@davidkiliani.de>, <g.gebhardt@meilhaus.de>, Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-ID: <49733E0F.7030305@gmail.com>


Since unsigned, it won't get negative after subtraction.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/meilhaus/me6000_ao.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/staging/meilhaus/me6000_ao.c
+++ b/drivers/staging/meilhaus/me6000_ao.c
@@ -2825,10 +2825,11 @@ int inline ao_stop_immediately(me6000_ao
 	int i;
 	uint32_t single_mask;
 
-	single_mask =
-	    (instance->ao_idx - ME6000_AO_SINGLE_STATUS_OFFSET <
-	     0) ? 0x0000 : (0x0001 << (instance->ao_idx -
-				       ME6000_AO_SINGLE_STATUS_OFFSET));
+	if (instance->ao_idx < ME6000_AO_SINGLE_STATUS_OFFSET)
+		single_mask = 0x0000;
+	else
+		single_mask = 0x0001 << (instance->ao_idx -
+				ME6000_AO_SINGLE_STATUS_OFFSET);
 
 	timeout =
 	    (instance->hardware_stop_delay >


Patches currently in gregkh-2.6 which might be from roel.kluin@gmail.com are

staging/staging-meilhaus-unsigned-won-t-get-negative-after-subtraction.patch
staging/staging-otus-logical-bit-and-confusion.patch
