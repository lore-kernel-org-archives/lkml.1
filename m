Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbZDHLwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbZDHLwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbZDHL2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51400 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764635AbZDHL1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:30 -0400
X-Sasl-enc: x4RjRvNfXwIVRWu0eWb6Fhde8PqfY/XMMPYLa791vsAM 1239190049
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 29/56] irda: Remove void casts
Date: Wed,  8 Apr 2009 12:22:01 +0100
Message-Id: <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 net/irda/discovery.c         |    4 ++--
 net/irda/ircomm/ircomm_lmp.c |    2 +-
 net/irda/iriap.c             |    2 +-
 net/irda/irnet/irnet_irda.c  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/irda/discovery.c b/net/irda/discovery.c
index a6f99b5..7fdc346 100644
--- a/net/irda/discovery.c
+++ b/net/irda/discovery.c
@@ -130,11 +130,11 @@ void irlmp_add_discovery_log(hashbin_t *cachelog, hashbin_t *log)
 	 * no need to lock it.
 	 * We just need to lock the global log in irlmp_add_discovery().
 	 */
-	discovery = (discovery_t *) hashbin_remove_first(log);
+	discovery = hashbin_remove_first(log);
 	while (discovery != NULL) {
 		irlmp_add_discovery(cachelog, discovery);
 
-		discovery = (discovery_t *) hashbin_remove_first(log);
+		discovery = hashbin_remove_first(log);
 	}
 
 	/* Delete the now empty log */
diff --git a/net/irda/ircomm/ircomm_lmp.c b/net/irda/ircomm/ircomm_lmp.c
index 67c99d2..6245b45 100644
--- a/net/irda/ircomm/ircomm_lmp.c
+++ b/net/irda/ircomm/ircomm_lmp.c
@@ -152,7 +152,7 @@ static void ircomm_lmp_flow_control(struct sk_buff *skb)
 
 	line = cb->line;
 
-	self = (struct ircomm_cb *) hashbin_lock_find(ircomm, line, NULL);
+	self = hashbin_lock_find(ircomm, line, NULL);
 	if (!self) {
 		IRDA_DEBUG(2, "%s(), didn't find myself\n", __func__ );
 		return;
diff --git a/net/irda/iriap.c b/net/irda/iriap.c
index 4a105dc..12cb0e9 100644
--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -251,7 +251,7 @@ void iriap_close(struct iriap_cb *self)
 		self->lsap = NULL;
 	}
 
-	entry = (struct iriap_cb *) hashbin_remove(iriap, (long) self, NULL);
+	entry = hashbin_remove(iriap, (long) self, NULL);
 	IRDA_ASSERT(entry == self, return;);
 
 	__iriap_close(self);
diff --git a/net/irda/irnet/irnet_irda.c b/net/irda/irnet/irnet_irda.c
index cf9a4b5..213f207 100644
--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -766,7 +766,7 @@ irnet_find_socket(irnet_socket *	self)
    * requested that nickname */
   if(err == 0)
     {
-      new = (irnet_socket *) hashbin_find(irnet_server.list,
+      new = hashbin_find(irnet_server.list,
 					  0, self->rname);
       if(new)
 	DEBUG(IRDA_SERV_INFO, "Socket 0x%p matches rname ``%s''.\n",
-- 
1.5.4.3

