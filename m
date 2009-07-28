Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZG1ICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZG1ICS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 04:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZG1ICR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 04:02:17 -0400
Received: from www84.your-server.de ([213.133.104.84]:53116 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZG1ICP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 04:02:15 -0400
Subject: [PATCH] fbcon: rotate upside down crash
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 10:01:58 +0200
Message-Id: <1248768118.2992.12.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is a bug fix for the frame console. 

The current frame buffer console upside down functionality will crash
using a font which has not a width of multiple by 8. 

The following 1 liner will fix the rotate_ud() function,

ChangeLog:
 Fix the rotate_ud() function not to crash in case of a font which has not a width of multiple by 8: The 
 inner loop of the font pixel copy should not access a bit outside the font memory area. Subtract the shift
 offset from the font width will prevent this.

 fbcon_rotate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Stefani Seibold <stefani@seibold.net>

--- linux-2.6.31-rc4.orig/drivers/video/console/fbcon_rotate.h	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.31-rc4/drivers/video/console/fbcon_rotate.h	2009-07-24 20:37:31.000000000 +0200
@@ -45,7 +45,7 @@
 	width = (width + 7) & ~7;
 
 	for (i = 0; i < height; i++) {
-		for (j = 0; j < width; j++) {
+		for (j = 0; j < width - shift; j++) {
 			if (pattern_test_bit(j, i, width, in))
 				pattern_set_bit(width - (1 + j + shift),
 						height - (1 + i),


