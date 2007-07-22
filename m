Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbXGVS0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbXGVS0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbXGVSZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:25:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:52165 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388AbXGVSZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=PcEJVg9q3CWeLRBxRYUlHEaBpCNYWiEH9F/USoMOUCODVo0Qy4aPz2LQBxG5H3ZjocXqSrK7kgpg9Nj2ezdZ4NRAs42s3hRNVF4wi7nhohwGCUZpPfWuc1vzb3en6MGwOvFW+lALe6UcJyYEAJL8VDnGJp4XJVbT3vYUmiYlGtI=
Message-ID: <46A3A0A9.3020100@googlemail.com>
Date: Sun, 22 Jul 2007 20:23:37 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Fix drivers/char/cyclades.c warning with CONFIG_PCI=n
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when CONFIG_PCI is not set I get this warning :

...

drivers/char/cyclades.c: In function 'cy_init':
drivers/char/cyclades.c:5488: warning: label 'err_unr' defined but not used

...


Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 9e0adfe..1fa0bda 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -5485,8 +5485,11 @@ static int __init cy_init(void)
 #endif
 
 	return 0;
+
+#ifdef CONFIG_PCI
 err_unr:
 	tty_unregister_driver(cy_serial_driver);
+#endif
 err_frtty:
 	put_tty_driver(cy_serial_driver);
 err:
