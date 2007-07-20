Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbXGTXdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbXGTXdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759769AbXGTXdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:33:01 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37870 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757304AbXGTXc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:32:58 -0400
Message-Id: <20070720225817.607502287@ayoka.breakpoint.cc>
User-Agent: quilt/0.46-1
Date: Sat, 21 Jul 2007 00:58:01 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] i2o: defined but not used.
Content-Disposition: inline; filename=i2o_exec_lct_notify_def_not_used.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got with randconfig
drivers/message/i2o/exec-osm.c:539: warning: 'i2o_exec_lct_notify' defined but
not used
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Index: b/drivers/message/i2o/exec-osm.c
===================================================================
--- a/drivers/message/i2o/exec-osm.c
+++ b/drivers/message/i2o/exec-osm.c
@@ -389,9 +389,7 @@ static void i2o_exec_lct_modified(struct
 	if (i2o_device_parse_lct(c) != -EAGAIN)
 		change_ind = c->lct->change_ind + 1;
 
-#ifdef CONFIG_I2O_LCT_NOTIFY_ON_CHANGES
 	i2o_exec_lct_notify(c, change_ind);
-#endif
 };
 
 /**
@@ -525,6 +523,7 @@ int i2o_exec_lct_get(struct i2o_controll
 	return rc;
 }
 
+#ifdef CONFIG_I2O_LCT_NOTIFY_ON_CHANGES
 /**
  *	i2o_exec_lct_notify - Send a asynchronus LCT NOTIFY request
  *	@c: I2O controller to which the request should be send
@@ -570,6 +569,13 @@ static int i2o_exec_lct_notify(struct i2
 	return 0;
 };
 
+#else
+static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
+{
+	return 0;
+}
+#endif
+
 /* Exec OSM driver struct */
 struct i2o_driver i2o_exec_driver = {
 	.name = OSM_NAME,

-- 

