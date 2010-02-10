Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0BJDsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:48:05 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:32839 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0BJDsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EfKdlsc5yeo6puLvHHobUAzPGs0IaUsVweU5NWHtb7UP/NUbzkculw/d/ZrO8ltN5R
         cnyMOULtjvLSJICFLiSfqLf7Vh03fP+Knkmm+3zsh4iEnQDnBcilEKmooQW0Y5icghk0
         0g6q6VS4shUndzVwJYEFvsONlMVISsAyrKyvM=
MIME-Version: 1.0
Date: Wed, 10 Feb 2010 03:47:59 +0000
Message-ID: <600adaf51002091947ta095cc5g7174684f57488e94@mail.gmail.com>
Subject: [RFC][PATCH] Allow change timing values to wait slow devices bring up 
	before try register an interface to IP-Config
From: Tiago Maluta <tiago.maluta@gmail.com>
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for previous attached patch in email.

--tm


>From e414000eed1a951bf03f125f5307bc1edffcecf1 Mon Sep 17 00:00:00 2001
From: Tiago Maluta <maluta@unifei.edu.br>
Date: Wed, 10 Feb 2010 03:34:49 +0000
Subject: [RFC][PATCH] Allow change timing values to wait slow devices
bring up before try register an interface
 to IP-Config (used on some drivers using Multi-purpose USB Networking
Framework)


Signed-off-by: Tiago Maluta <maluta@unifei.edu.br>
---
 drivers/net/Kconfig |   18 ++++++++++++++++++
 net/ipv4/ipconfig.c |    4 ++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index dd9a09c..12fbe4a 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -38,6 +38,24 @@ config IFB
 	  'ifb1' etc.
 	  Look at the iproute2 documentation directory for usage etc

+config NETDEVICES_DELAY_PRE_OPEN
+	int "Define the delay before opening net devices (ms)"
+	depends on NETDEVICES
+	default 500
+	help
+	    Some devices may not work properly due to a delay from hardware bring
+	    the interface up. This value add a delay, in miilliseconds, before
+	    kernel search and register the interface. Default value is 500ms.
+
+config NETDEVICES_DELAY_POST_OPEN
+	int "Define the delay after opening net devices (s)"
+	depends on NETDEVICES
+	default 1
+	help
+	    Some devices may not work properly due to a delay from hardware bring
+	    the interface up. This value add a delay, in seconds, after
+	    kernel search and register the interface. Default value is 1s.
+
 config DUMMY
 	tristate "Dummy net driver support"
 	---help---
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 10a6a60..2530126 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -86,8 +86,8 @@
 #endif

 /* Define the friendly delay before and after opening net devices */
-#define CONF_PRE_OPEN		500	/* Before opening: 1/2 second */
-#define CONF_POST_OPEN		1	/* After opening: 1 second */
+#define CONF_PRE_OPEN		CONFIG_NETDEVICES_DELAY_PRE_OPEN	/* Before
opening. Default is 1/2 second */
+#define CONF_POST_OPEN		CONFIG_NETDEVICES_DELAY_POST_OPEN	/* After
opening. Default is 1 second */

 /* Define the timeout for waiting for a DHCP/BOOTP/RARP reply */
 #define CONF_OPEN_RETRIES 	2	/* (Re)open devices twice */
-- 
1.6.4.2
