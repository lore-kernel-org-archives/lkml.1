Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZGMRzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZGMRzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZGMRzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:55:22 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:60894 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbZGMRzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NRrF2MVL+4opvksOwVHLu4gSlMLDOw9ekO3c7Uj+V8BbTuQ8XkuacXDo+vI7GjebEG
         vRzeIslKNYQmGreK06BEFBVlVvIx6V4c77nyv9iH1QTq5g+C7fY6+3QB3Shm//N7fPgV
         xC87ilO9bgz3vz+DW+40AR425eCruzpGk65Io=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:01:57 +0200
Message-Id: <20090713180157.15985.29900.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
References: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/10] Staging: rtl8187se: rename struct ieee80211_hdr_QOS to struct ieee80211_hdr_4addrqos
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se: rename struct ieee80211_hdr_QOS to struct ieee80211_hdr_4addrqos

Rename struct ieee80211_hdr_QOS to struct ieee80211_hdr_4addrqos
and QOS_ctl field to qos_ctl (to match the naming used by rtl8192su).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/TODO                     |    1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    4 ++--
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |   18 +++++++++---------
 3 files changed, 11 insertions(+), 12 deletions(-)

Index: b/drivers/staging/rtl8187se/TODO
===================================================================
--- a/drivers/staging/rtl8187se/TODO
+++ b/drivers/staging/rtl8187se/TODO
@@ -1,6 +1,5 @@
 TODO:
 - prepare private ieee80211 stack for merge with rtl8192su's version:
-  - rename struct ieee80211_hdr_QOS to struct ieee80211_hdr_4addrqos
   - add hwsec_active flag to struct ieee80211_device
   - add bHwSec flag to cb_desc structure
   - switch ieee80211.h to use <linux/ieee80211.h>
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -180,7 +180,7 @@ struct ieee80211_hdr_4addr {
 	u8 addr4[ETH_ALEN];
 } __attribute__ ((packed));
 
-struct ieee80211_hdr_QOS {
+struct ieee80211_hdr_4addrqos {
 	u16 frame_ctl;
 	u16 duration_id;
 	u8 addr1[ETH_ALEN];
@@ -188,7 +188,7 @@ struct ieee80211_hdr_QOS {
 	u8 addr3[ETH_ALEN];
 	u16 seq_ctl;
 	u8 addr4[ETH_ALEN];
-	u16 QOS_ctl;
+	u16 qos_ctl;
 } __attribute__ ((packed));
 
 struct ieee80211_hdr_3addr {
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -105,12 +105,12 @@ ieee80211_frag_cache_get(struct ieee8021
 	unsigned int seq = WLAN_GET_SEQ_SEQ(sc);
 	struct ieee80211_frag_entry *entry;
 	struct ieee80211_hdr_3addrqos *hdr_3addrqos;
-	struct ieee80211_hdr_QOS *hdr_4addr_QoS;
+	struct ieee80211_hdr_4addrqos *hdr_4addrqos;
 	u8 tid;
 
 	if (((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
-	  hdr_4addr_QoS = (struct ieee80211_hdr_QOS *)hdr;
-	  tid = le16_to_cpu(hdr_4addr_QoS->QOS_ctl) & IEEE80211_QOS_TID;
+	  hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
+	  tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
 	  tid = UP2AC(tid);
 	  tid ++;
 	} else if (IEEE80211_QOS_HAS_SEQ(fc)) {
@@ -172,12 +172,12 @@ static int ieee80211_frag_cache_invalida
 	unsigned int seq = WLAN_GET_SEQ_SEQ(sc);
 	struct ieee80211_frag_entry *entry;
 	struct ieee80211_hdr_3addrqos *hdr_3addrqos;
-	struct ieee80211_hdr_QOS *hdr_4addr_QoS;
+	struct ieee80211_hdr_4addrqos *hdr_4addrqos;
 	u8 tid;
 
 	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
-	  hdr_4addr_QoS = (struct ieee80211_hdr_QOS *)hdr;
-	  tid = le16_to_cpu(hdr_4addr_QoS->QOS_ctl) & IEEE80211_QOS_TID;
+	  hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
+	  tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
 	  tid = UP2AC(tid);
 	  tid ++;
 	} else if (IEEE80211_QOS_HAS_SEQ(fc)) {
@@ -378,13 +378,13 @@ static int is_duplicate_packet(struct ie
 	u16 *last_seq, *last_frag;
 	unsigned long *last_time;
 	struct ieee80211_hdr_3addrqos *hdr_3addrqos;
-	struct ieee80211_hdr_QOS *hdr_4addr_QoS;
+	struct ieee80211_hdr_4addrqos *hdr_4addrqos;
 	u8 tid;
 
 	//TO2DS and QoS
 	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
-	  hdr_4addr_QoS = (struct ieee80211_hdr_QOS *)header;
-	  tid = le16_to_cpu(hdr_4addr_QoS->QOS_ctl) & IEEE80211_QOS_TID;
+	  hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)header;
+	  tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
 	  tid = UP2AC(tid);
 	  tid ++;
 	} else if(IEEE80211_QOS_HAS_SEQ(fc)) { //QoS
