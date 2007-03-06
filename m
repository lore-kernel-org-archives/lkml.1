Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbXCFUDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbXCFUDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXCFUCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:02:44 -0500
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:26679 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751226AbXCFUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:02:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=1pmoJvZ2joUQpwbFR/s1HHBdf3w9YBxy7+jnVKEXitlNWqw/OyPxitrzOwNi++tb3jwRknNvIOPSpzyV443Qx8Q82+fJuQl05sR+veBrpuvYmIYcMlc8Lv5uLGSMRjX5y5gqtgXvnUteggN7pmVwlTo4BoY8b+kZWossLW5LqTw=  ;
X-YMail-OSG: _I6qctQVM1lEeuRQWtkovFBvdprWbtmkAvgxRj7optKa9j3wMLO9GGkWYG4sxOpo_bWnWiH.btq1Vc2qSXubqJRrCF7QfsDklEcoT6iKG0kOyeWVeb0qtc12GZI5Ybq2Vfajrvy1PCWJHRB1710y7R6XQA--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc2-git] rduc pnp syslog spam
Date: Tue, 6 Mar 2007 12:02:25 -0800
User-Agent: KMail/1.7.1
Cc: Adam Belay <abelay@novell.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703061202.25728.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make some normal code paths in PNP stop issuing syslog spam.  Since PNP
issues calls regardless of device capablities, it's no surprise when
some of those devices don't support those calls!

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Index: linux-2.6/drivers/pnp/manager.c
===================================================================
--- linux-2.6.orig/drivers/pnp/manager.c	2006-07-01 13:34:37.000000000 -0700
+++ linux-2.6/drivers/pnp/manager.c	2007-03-06 04:35:19.000000000 -0800
@@ -451,7 +451,7 @@ int pnp_auto_config_dev(struct pnp_dev *
 		return -EINVAL;
 
 	if(!pnp_can_configure(dev)) {
-		pnp_info("Device %s does not support resource configuration.", dev->dev.bus_id);
+		pnp_dbg("Device %s does not support resource configuration.", dev->dev.bus_id);
 		return -ENODEV;
 	}
 
@@ -482,7 +482,7 @@ int pnp_auto_config_dev(struct pnp_dev *
 int pnp_start_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_write(dev)) {
-		pnp_info("Device %s does not support activation.", dev->dev.bus_id);
+		pnp_dbg("Device %s does not support activation.", dev->dev.bus_id);
 		return -EINVAL;
 	}
 
@@ -506,7 +506,7 @@ int pnp_start_dev(struct pnp_dev *dev)
 int pnp_stop_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_disable(dev)) {
-		pnp_info("Device %s does not support disabling.", dev->dev.bus_id);
+		pnp_dbg("Device %s does not support disabling.", dev->dev.bus_id);
 		return -EINVAL;
 	}
 	if (dev->protocol->disable(dev)<0) {
