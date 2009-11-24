Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbZKXKWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbZKXKWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbZKXKWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:22:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbZKXKWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:22:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: greg@kroah.com, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] tty/of_serial: add missing ns16550a id
Date: Tue, 24 Nov 2009 10:22:41 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31bisect; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, grant.likely@secretlab.ca,
       john.williams@petalogix.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911241022.41078.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+TPNw09zFRudsgVFmKbL6WlKjX/YQwarZv36Y
 WAJzcL9VxOzP+56Wc42KANV1q8BqF6O9/jwedfn0REZPexMA96
 elHf+9u7bNvwOv1KljTUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Many boards have a bug-free ns16550 compatible serial port, which we should
register as PORT_16550A. This introduces a new value "ns16550a" for the
compatible property of of_serial to let a firmware choose that model instead
of using the crippled PORT_16550 mode.

Reported-by: Alon Ziv <alonz@nolaviz.org>
Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
Please apply to the tty tree for 2.6.33

--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -161,6 +161,7 @@ static int of_platform_serial_remove(struct of_device *ofdev)
 static struct of_device_id __devinitdata of_platform_serial_table[] = {
 	{ .type = "serial", .compatible = "ns8250",   .data = (void *)PORT_8250, },
 	{ .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
+	{ .type = "serial", .compatible = "ns16550a", .data = (void *)PORT_16550A, },
 	{ .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
 	{ .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
 	{ .type = "serial", .compatible = "ns16850",  .data = (void *)PORT_16850, },
