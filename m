Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbYAKMKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbYAKMKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbYAKMJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:09:33 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43079 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762196AbYAKMJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:09:31 -0500
Date: Fri, 11 Jan 2008 15:08:52 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Harry J Mason <hjm03r@ecs.soton.ac.uk>
Subject: [1/1] w1: remove unused and confusing variable.
Message-ID: <20080111120852.GA25530@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This patch removes variable which actually is not used (except assigning
it a value) and confusing break out of the family checking loop.
Found by Harry J Mason <hjm03r@ecs.soton.ac.uk>.

Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 0702173..89300e6 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -675,7 +675,6 @@ static void w1_slave_found(void *data, u64 rn)
 	struct w1_slave *sl;
 	struct list_head *ent;
 	struct w1_reg_num *tmp;
-	int family_found = 0;
 	struct w1_master *dev;
 	u64 rn_le = cpu_to_le64(rn);
 
@@ -698,9 +697,6 @@ static void w1_slave_found(void *data, u64 rn)
 		    sl->reg_num.crc == tmp->crc) {
 			set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
 			break;
-		} else if (sl->reg_num.family == tmp->family) {
-			family_found = 1;
-			break;
 		}
 
 		slave_count++;


-- 
	Evgeniy Polyakov
