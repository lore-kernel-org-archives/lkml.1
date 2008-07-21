Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYGUTes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYGUTes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYGUTdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:33:51 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34172 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbYGUTdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:33:51 -0400
Date: Mon, 21 Jul 2008 22:33:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb/siano/: cleanups
Message-ID: <20080721193344.GE14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- mark smscore_module_init() as __init
- mark smscore_module_exit as __exit
- make the following needlessly global code static:
  - smscoreapi.c: struct g_smscore_notifyees
  - smscoreapi.c: struct g_smscore_devices
  - smscoreapi.c: struct g_smscore_deviceslock
  - smscoreapi.c: struct g_smscore_registry
  - smscoreapi.c: struct g_smscore_registrylock
  - smscoreapi.c: smscore_module_init()
  - smscoreapi.c: smscore_module_exit()
  - smsdvb.c: struct g_smsdvb_clients
  - smsdvb.c: struct g_smsdvb_clientslock

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/dvb/siano/smscoreapi.c |   14 +++++++-------
 drivers/media/dvb/siano/smsdvb.c     |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

0a5990e3265d7a29ced7effd8d33686169502315 
diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index b4b8ed7..c5f45fe 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -110,12 +110,12 @@ struct smscore_registry_entry_t {
 	enum sms_device_type_st	type;
 };
 
-struct list_head g_smscore_notifyees;
-struct list_head g_smscore_devices;
-struct mutex g_smscore_deviceslock;
+static struct list_head g_smscore_notifyees;
+static struct list_head g_smscore_devices;
+static struct mutex g_smscore_deviceslock;
 
-struct list_head g_smscore_registry;
-struct mutex g_smscore_registrylock;
+static struct list_head g_smscore_registry;
+static struct mutex g_smscore_registrylock;
 
 static int default_mode = 4;
 
@@ -1187,7 +1187,7 @@ int smsclient_sendrequest(struct smscore_client_t *client,
 }
 
 
-int smscore_module_init(void)
+static int __init smscore_module_init(void)
 {
 	int rc = 0;
 
@@ -1209,7 +1209,7 @@ int smscore_module_init(void)
 	return rc;
 }
 
-void smscore_module_exit(void)
+static void __exit smscore_module_exit(void)
 {
 
 	kmutex_lock(&g_smscore_deviceslock);
diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/dvb/siano/smsdvb.c
index 6f9c185..229274a 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -27,8 +27,8 @@
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-struct list_head g_smsdvb_clients;
-struct mutex g_smsdvb_clientslock;
+static struct list_head g_smsdvb_clients;
+static struct mutex g_smsdvb_clientslock;
 
 static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 {

