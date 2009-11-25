Return-Path: <linux-kernel-owner+w=401wt.eu-S934047AbZKYBPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbZKYBPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933665AbZKYBPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:15:21 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:50843 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738AbZKYBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:15:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=kYadRDIVe0Vj6JDmLxZ7oew6Fk4WKe8VXZddALRavsBdu+JLKdSgtrL7ruym7roKjd
         /q/NmXwgzpUfTYPDbla6YrA9WdJDwKGwVirhEMu+SLISME9FjBXIfvd5pdlE2/7AyxWp
         2808Uzj8nIqQie67Ol5qFGlWQqKIZxVPkUuxY=
MIME-Version: 1.0
Date: Wed, 25 Nov 2009 12:15:26 +1100
Message-ID: <d45a3acc0911241715jcb41224y7871ea0878b9df9e@mail.gmail.com>
Subject: [PATCH 1/3] X25: Move SYSCTL ifdefs into header
From: andrew hendry <andrew.hendry@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-x25@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moves the CONFIG_SYSCTL ifdefs in x25_init into header.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

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
