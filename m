Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0APJ2L (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194Ab0APJ2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:28:09 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:41358 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0APJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:28:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 1/1] HWMON: amc6821, fix lock imbalance
Date: Sat, 16 Jan 2010 10:28:01 +0100
Message-Id: <1263634081-6644-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a lock imbalance in set_fan1_div. data->update_lock
is unlocked twice on a fail path.

Triggerable by writing value other than 2 and 4 to fan1_div.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/hwmon/amc6821.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 1c89d92..fa9708c 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -686,7 +686,6 @@ static ssize_t set_fan1_div(
 		data->fan1_div = 4;
 		break;
 	default:
-		mutex_unlock(&data->update_lock);
 		count = -EINVAL;
 		goto EXIT;
 	}
-- 
1.6.5.7

