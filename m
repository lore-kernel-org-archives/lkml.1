Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYBVReJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYBVReJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYBVRd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:33:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYBVRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nigdICR0ZJR3Y/KjggkTxaDgdV8dbs18mNN6ojlRz1Bw4lqLQoZRF3O37fi5dqQ0lbp6oqoUgeI+cOFnR7khfHx18kM6ryH47eIjQC+NGfuIiRI0p87AZevYWVakBOX1htxi9gTk9CV0vKMbTKm2DBMNLyNmwQ1O27hB/IMnZe8=
Subject: [PATCH 1/2] char: fix sparse shadowed variable warnings in esp.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 09:34:08 -0800
Message-Id: <1203701648.5962.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flags only use was in spin_lock_irqsave/spin_lock_irgrestore pairs, no
need to redeclare for each one.

drivers/char/esp.c:1599:17: warning: symbol 'flags' shadows an earlier one
drivers/char/esp.c:1517:16: originally declared here
drivers/char/esp.c:1615:17: warning: symbol 'flags' shadows an earlier one
drivers/char/esp.c:1517:16: originally declared here
drivers/char/esp.c:1631:17: warning: symbol 'flags' shadows an earlier one
drivers/char/esp.c:1517:16: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/esp.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/char/esp.c b/drivers/char/esp.c
index c01e26d..01fbddd 100644
--- a/drivers/char/esp.c
+++ b/drivers/char/esp.c
@@ -1596,8 +1596,6 @@ static int set_esp_config(struct esp_struct * info,
 
 	if ((new_config.flow_off != info->config.flow_off) ||
 	    (new_config.flow_on != info->config.flow_on)) {
-		unsigned long flags;
-
 		info->config.flow_off = new_config.flow_off;
 		info->config.flow_on = new_config.flow_on;
 
@@ -1612,8 +1610,6 @@ static int set_esp_config(struct esp_struct * info,
 
 	if ((new_config.rx_trigger != info->config.rx_trigger) ||
 	    (new_config.tx_trigger != info->config.tx_trigger)) {
-		unsigned long flags;
-
 		info->config.rx_trigger = new_config.rx_trigger;
 		info->config.tx_trigger = new_config.tx_trigger;
 		spin_lock_irqsave(&info->lock, flags);
@@ -1628,8 +1624,6 @@ static int set_esp_config(struct esp_struct * info,
 	}
 
 	if (new_config.rx_timeout != info->config.rx_timeout) {
-		unsigned long flags;
-
 		info->config.rx_timeout = new_config.rx_timeout;
 		spin_lock_irqsave(&info->lock, flags);
 
-- 
1.5.4.2.200.g99e75


