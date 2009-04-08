Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbZDHOIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbZDHOIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932606AbZDHOGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:06:43 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58986 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933205AbZDHOGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:06:41 -0400
X-Sasl-enc: 9hYmZuzdcWk0Gr3ieNg/IGTq4EnCIAkxeQ7jUXEuC9TO 1239199600
Message-ID: <49DCAF6D.6080704@fastmail.fm>
Date: Wed, 08 Apr 2009 15:06:37 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 29/56] irda: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080531p5167e7f6j12617436084fabfa@mail.gmail.com>
In-Reply-To: <36ca99e90904080531p5167e7f6j12617436084fabfa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed patch

Thanks,

Jack

--

irda: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 net/irda/discovery.c         |    4 ++--
 net/irda/ircomm/ircomm_lmp.c |    2 +-
 net/irda/iriap.c             |    2 +-
 net/irda/irnet/irnet_irda.c  |    3 +--
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/irda/discovery.c b/net/irda/discovery.c
index a6f99b5..7fdc346 100644
--- a/net/irda/discovery.c
+++ b/net/irda/discovery.c
@@ -130,11 +130,11 @@ void irlmp_add_discovery_log(hashbin_t *cachelog,
hashbin_t *log)
      * no need to lock it.
      * We just need to lock the global log in irlmp_add_discovery().
      */
-    discovery = (discovery_t *) hashbin_remove_first(log);
+    discovery = hashbin_remove_first(log);
     while (discovery != NULL) {
         irlmp_add_discovery(cachelog, discovery);
 
-        discovery = (discovery_t *) hashbin_remove_first(log);
+        discovery = hashbin_remove_first(log);
     }
 
     /* Delete the now empty log */
diff --git a/net/irda/ircomm/ircomm_lmp.c b/net/irda/ircomm/ircomm_lmp.c
index 67c99d2..6245b45 100644
--- a/net/irda/ircomm/ircomm_lmp.c
+++ b/net/irda/ircomm/ircomm_lmp.c
@@ -152,7 +152,7 @@ static void ircomm_lmp_flow_control(struct sk_buff *skb)
 
     line = cb->line;
 
-    self = (struct ircomm_cb *) hashbin_lock_find(ircomm, line, NULL);
+    self = hashbin_lock_find(ircomm, line, NULL);
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
 
-    entry = (struct iriap_cb *) hashbin_remove(iriap, (long) self, NULL);
+    entry = hashbin_remove(iriap, (long) self, NULL);
     IRDA_ASSERT(entry == self, return;);
 
     __iriap_close(self);
diff --git a/net/irda/irnet/irnet_irda.c b/net/irda/irnet/irnet_irda.c
index cf9a4b5..3a89247 100644
--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -766,8 +766,7 @@ irnet_find_socket(irnet_socket *    self)
    * requested that nickname */
   if(err == 0)
     {
-      new = (irnet_socket *) hashbin_find(irnet_server.list,
-                      0, self->rname);
+      new = hashbin_find(irnet_server.list, 0, self->rname);
       if(new)
     DEBUG(IRDA_SERV_INFO, "Socket 0x%p matches rname ``%s''.\n",
           new, new->rname);
