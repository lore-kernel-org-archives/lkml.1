Return-Path: <linux-kernel-owner+w=401wt.eu-S932606AbZLNWCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbZLNWCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbZLNWCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:02:13 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:44224 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbZLNWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:02:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=J2305g4OL8ZJCD7MQk9lvP25WkFygH4C90sQQXYFxw3FESwcdZ0jk1cC+uqYpGdFlP
         tUrz2gy72xOint0EnMiZL1VU4B0psRJwzaUX2OrTgrkyyb9NwfDARkd/3UW2WA/ysq7g
         /9dVvHEOGynLWLaD4l3UJAFBZLizkjN8gD1Eo=
MIME-Version: 1.0
Date: Tue, 15 Dec 2009 09:02:11 +1100
Message-ID: <d45a3acc0912141402v69ea4ccet143f8ef7bc04e585@mail.gmail.com>
Subject: [RESEND PATCH 1/3] X25: Move SYSCTL ifdefs into header
From: andrew hendry <andrew.hendry@gmail.com>
To: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moves the CONFIG_SYSCTL ifdefs in x25_init into header.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff -uprN -X a/Documentation/dontdiff a/include/net/x25.h b/include/net/x25.h
--- a/include/net/x25.h	2009-11-10 11:32:31.000000000 +1100
+++ b/include/net/x25.h	2009-11-25 09:05:21.000000000 +1100
@@ -287,8 +287,14 @@ extern unsigned long x25_display_timer(s
 extern void x25_check_rbuf(struct sock *);

 /* sysctl_net_x25.c */
+#ifdef CONFIG_SYSCTL
 extern void x25_register_sysctl(void);
 extern void x25_unregister_sysctl(void);
+#else
+static inline void x25_register_sysctl(void) {};
+static inline void x25_unregister_sysctl(void) {};
+#endif /* CONFIG_SYSCTL */
+
 struct x25_skb_cb {
 	unsigned flags;
 };
diff -uprN -X a/Documentation/dontdiff a/net/x25/af_x25.c b/net/x25/af_x25.c
--- a/net/x25/af_x25.c	2009-11-17 10:30:18.000000000 +1100
+++ b/net/x25/af_x25.c	2009-11-25 09:04:25.000000000 +1100
@@ -1667,9 +1667,7 @@ static int __init x25_init(void)

 	printk(KERN_INFO "X.25 for Linux Version 0.2\n");

-#ifdef CONFIG_SYSCTL
 	x25_register_sysctl();
-#endif
 	x25_proc_init();
 out:
 	return rc;
@@ -1682,9 +1680,7 @@ static void __exit x25_exit(void)
 	x25_link_free();
 	x25_route_free();

-#ifdef CONFIG_SYSCTL
 	x25_unregister_sysctl();
-#endif

 	unregister_netdevice_notifier(&x25_dev_notifier);
