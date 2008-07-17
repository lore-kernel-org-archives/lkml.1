Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbYGQPPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbYGQPPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYGQPOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:14:53 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:43627
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbYGQPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:14:52 -0400
Subject: [PATCH] synclink_gt leave transmitter in reset state after
	configuration
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 09:14:23 -0500
Message-Id: <1216304063.3842.11.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leave the transmitter in reset state after configuration
so that transmit signal is held at mark until transmitter
is explicitly enabled by application, otherwise transmitter
sends idle pattern.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2008-07-17 08:39:06.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2008-07-17 09:05:24.000000000 -0500
@@ -4157,7 +4157,7 @@ static void sync_mode(struct slgt_info *
 	 * 01      enable
 	 * 00      auto-CTS enable
 	 */
-	val = 0;
+	val = BIT2;
 
 	switch(info->params.mode) {
 	case MGSL_MODE_MONOSYNC: val |= BIT14 + BIT13; break;


