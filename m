Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYBUSXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYBUSXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 13:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYBUSXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 13:23:22 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:22509 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYBUSXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 13:23:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FyzCYemN7ofswJ/7kTIWYg2THB1pRASfbVYPkPzLR8RrwMJ8U9wv2jbXR7XiJQ2eyZQ3/qvmpsWaFsLJoA3R21qqlw9/lf658S1E7Mw37073tO384LZAvogbHWDYIrRgcl+MJR/gJILWnuNsC0YJYPK6AVPa8XZLaDLOum6zXjc=
Subject: [PATCH] eicon: fix sparse integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 10:23:30 -0800
Message-Id: <1203618210.20345.51.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/hardware/eicon/message.c:745:47: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/message.c:761:45: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/message.c:9122:16: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/message.c:9147:16: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/message.c:9173:14: warning: Using plain integer as NULL pointer
drivers/isdn/hardware/eicon/divasmain.c:396:23: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/isdn/hardware/eicon/divasmain.c |    2 +-
 drivers/isdn/hardware/eicon/message.c   |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/divasmain.c b/drivers/isdn/hardware/eicon/divasmain.c
index 6d39f93..5fcbdcc 100644
--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -393,7 +393,7 @@ void diva_free_dma_map(void *hdev, struct _diva_dma_map_entry *pmap)
 	dma_addr_t dma_handle;
 	void *addr_handle;
 
-	for (i = 0; (pmap != 0); i++) {
+	for (i = 0; (pmap != NULL); i++) {
 		diva_get_dma_map_entry(pmap, i, &cpu_addr, &phys_addr);
 		if (!cpu_addr) {
 			break;
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index 1ff98e7..599fed8 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -742,7 +742,7 @@ static void start_internal_command (dword Id, PLCI   *plci, t_std_internal_comma
   else
   {
     i = 1;
-    while (plci->internal_command_queue[i] != 0)
+    while (plci->internal_command_queue[i] != NULL)
       i++;
     plci->internal_command_queue[i] = command_function;
   }
@@ -758,7 +758,7 @@ static void next_internal_command (dword Id, PLCI   *plci)
 
   plci->internal_command = 0;
   plci->internal_command_queue[0] = NULL;
-  while (plci->internal_command_queue[1] != 0)
+  while (plci->internal_command_queue[1] != NULL)
   {
     for (i = 0; i < MAX_INTERNAL_COMMAND_LEVELS - 1; i++)
       plci->internal_command_queue[i] = plci->internal_command_queue[i+1];
@@ -9119,7 +9119,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER   *a, PLCI   *plci, APPL   *appl, byte ho
         dbug(1,dprintf("AdvSigPlci=0x%x",a->AdvSignalPLCI));
         return 0x2001; /* codec in use by another application */
       }
-      if(plci!=0)
+      if(plci!=NULL)
       {
         a->AdvSignalPLCI = plci;
         plci->tel=ADV_VOICE;
@@ -9144,7 +9144,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER   *a, PLCI   *plci, APPL   *appl, byte ho
         }
                                                /* indicate D-ch connect if  */
       }                                        /* codec is connected OK     */
-      if(plci!=0)
+      if(plci!=NULL)
       {
         a->AdvSignalPLCI = plci;
         plci->tel=ADV_VOICE;
@@ -9170,7 +9170,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER   *a, PLCI   *plci, APPL   *appl, byte ho
   {
     if(hook_listen) return 0x300B;               /* Facility not supported */
                                                  /* no hook with SCOM      */
-    if(plci!=0) plci->tel = CODEC;
+    if(plci!=NULL) plci->tel = CODEC;
     dbug(1,dprintf("S/SCOM codec"));
     /* first time we use the scom-s codec we must shut down the internal   */
     /* handset application of the card. This can be done by an assign with */
@@ -14604,7 +14604,7 @@ static void channel_xmit_extended_xon (PLCI   * plci) {
   int max_ch = ARRAY_SIZE(a->ch_flow_control);
   int i, one_requested = 0;
 
-  if ((!plci) || (!plci->Id) || ((a = plci->adapter) == 0)) {
+  if ((!plci) || (!plci->Id) || ((a = plci->adapter) == NULL)) {
     return;
   }
 
-- 
1.5.4.2.200.g99e75



