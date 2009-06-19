Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbZFSV3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbZFSV3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbZFSV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:29:23 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:58133 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZFSV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:29:22 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: hjk@linutronix.de
Cc: lm-sensors@lm-sensors.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] HWMON: max6650, fix lock imbalance
Date: Fri, 19 Jun 2009 23:26:35 +0200
Message-Id: <1245446795-1901-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omitted update_lock to one switch/case in set_div.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hwmon/max6650.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 86142a8..58f66be 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -418,6 +418,7 @@ static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
 		data->count = 3;
 		break;
 	default:
+		mutex_unlock(&data->update_lock);
 		dev_err(&client->dev,
 			"illegal value for fan divider (%d)\n", div);
 		return -EINVAL;
-- 
1.6.3.2

