Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab0BGTMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 14:12:39 -0500
Received: from 87-194-149-168.bethere.co.uk ([87.194.149.168]:57758 "EHLO
	svr2.cnick.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756543Ab0BGTMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 14:12:38 -0500
X-Greylist: delayed 874 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Feb 2010 14:12:37 EST
From: chris.nicholson@cnick.org.uk
To: gregkh@suse.de, andrew@lunn.ch
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chris Nicholson <chris@localhost.localdomain>
Subject: [PATCH] Staging: batman-adv: fix checkpatch.pl issues in hard-interface.c This is a patch to the hard-interface.c file that fixes up the checkpatch.pl issues Signed-off-by: Chris Nicholson <chris.nicholson@cnick.org.uk>
Date: Sun,  7 Feb 2010 18:57:43 +0000
Message-Id: <1265569063-3973-1-git-send-email-chris.nicholson@cnick.org.uk>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 07 Feb 2010 18:57:40.0411 (UTC) FILETIME=[6C16E0B0:01CAA827]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Nicholson <chris@localhost.localdomain>

---
 drivers/staging/batman-adv/hard-interface.c |   40 +++++++++++++++++---------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
index 5ea35da..c4ed846 100644
--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -87,9 +87,15 @@ static void check_known_mac_addr(uint8_t *addr)
 			continue;
 
 		addr_to_string(mac_string, addr);
-		debug_log(LOG_TYPE_WARN, "The newly added mac address (%s) already exists on: %s\n",
-		          mac_string, batman_if->dev);
-		debug_log(LOG_TYPE_WARN, "It is strongly recommended to keep mac addresses unique to avoid problems!\n");
+		debug_log(LOG_TYPE_WARN, "The newly added mac address (%s) "
+							"already exists on: "
+							"%s\n",
+							mac_string,
+							batman_if->dev);
+		debug_log(LOG_TYPE_WARN, "It is strongly recommended to "
+							"keep mac addresses "
+							"unique avoid problems!"
+							"\n");
 	}
 	rcu_read_unlock();
 }
@@ -121,7 +127,8 @@ static int hardif_is_interface_up(char *dev)
 	if ((!list_empty(&if_list)) &&
 	    strncmp(((struct batman_if *)if_list.next)->dev, dev, IFNAMSIZ) &&
 	    !(((struct batman_if *)if_list.next)->if_active == IF_ACTIVE) &&
-	    !(((struct batman_if *)if_list.next)->if_active == IF_TO_BE_ACTIVATED) &&
+	    !(((struct batman_if *)if_list.next)->if_active ==
+							IF_TO_BE_ACTIVATED) &&
 	    (!main_if_was_up())) {
 		rcu_read_unlock();
 		goto end;
@@ -172,7 +179,7 @@ void hardif_deactivate_interface(struct batman_if *batman_if)
 	active_ifs--;
 
 	debug_log(LOG_TYPE_NOTICE, "Interface deactivated: %s\n",
-	          batman_if->dev);
+							batman_if->dev);
 }
 
 /* (re)activate given interface. */
@@ -236,7 +243,7 @@ static void hardif_activate_interface(struct batman_if *batman_if)
 		set_main_if_addr(batman_if->net_dev->dev_addr);
 
 	debug_log(LOG_TYPE_NOTICE, "Interface activated: %s\n",
-	          batman_if->dev);
+							batman_if->dev);
 
 	return;
 
@@ -324,7 +331,8 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if = kmalloc(sizeof(struct batman_if), GFP_KERNEL);
 
 	if (!batman_if) {
-		debug_log(LOG_TYPE_WARN, "Can't add interface (%s): out of memory\n", dev);
+		debug_log(LOG_TYPE_WARN, "Can't add interface (%s): out of "
+							"memory\n", dev);
 		return -1;
 	}
 
@@ -339,7 +347,8 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if->packet_buff = kmalloc(batman_if->packet_len, GFP_KERNEL);
 
 	if (!batman_if->packet_buff) {
-		debug_log(LOG_TYPE_WARN, "Can't add interface packet (%s): out of memory\n", dev);
+		debug_log(LOG_TYPE_WARN, "Can't add interface packet (%s): out "
+							"of memory\n", dev);
 		goto out;
 	}
 
@@ -389,7 +398,10 @@ int hardif_add_interface(char *dev, int if_num)
 	spin_unlock(&orig_hash_lock);
 
 	if (!hardif_is_interface_up(batman_if->dev))
-		debug_log(LOG_TYPE_WARN, "Not using interface %s (retrying later): interface not active\n", batman_if->dev);
+		debug_log(LOG_TYPE_WARN, "Not using interface %s (retrying "
+							"later): interface "
+							"not active\n",
+							batman_if->dev);
 	else
 		hardif_activate_interface(batman_if);
 
@@ -400,8 +412,7 @@ int hardif_add_interface(char *dev, int if_num)
 	return 1;
 
 out:
-	if (batman_if->packet_buff)
-		kfree(batman_if->packet_buff);
+	kfree(batman_if->packet_buff);
 	kfree(batman_if);
 	kfree(dev);
 	return -1;
@@ -413,7 +424,7 @@ char hardif_get_active_if_num(void)
 }
 
 static int hard_if_event(struct notifier_block *this,
-                            unsigned long event, void *ptr)
+					unsigned long event, void *ptr)
 {
 	struct net_device *dev = (struct net_device *)ptr;
 	struct batman_if *batman_if = get_batman_if_by_name(dev->name);
@@ -436,7 +447,8 @@ static int hard_if_event(struct notifier_block *this,
 		break;
 	/* NETDEV_CHANGEADDR - mac address change - what are we doing here ? */
 	default:
-		/* debug_log(LOG_TYPE_CRIT, "hard_if_event: %s %i\n", dev->name, event); */
+		/* debug_log(LOG_TYPE_CRIT, "hard_if_event: %s %i\n",
+							 dev->name, event); */
 		break;
 	};
 
@@ -447,5 +459,5 @@ out:
 }
 
 struct notifier_block hard_if_notifier = {
-        .notifier_call = hard_if_event,
+	.notifier_call = hard_if_event,
 };
-- 
1.6.6

