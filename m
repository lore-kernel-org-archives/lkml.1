Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZLASCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZLASCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZLASC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:02:29 -0500
Received: from kroah.org ([198.145.64.141]:52008 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbZLASC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:02:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] tty/of_serial: add missing ns16550a id
Date: Tue,  1 Dec 2009 09:59:06 -0800
Message-Id: <1259690346-12469-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091201174341.GB31972@kroah.com>
References: <20091201174341.GB31972@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/of_serial.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
index 02406ba..cdf172e 100644
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
-- 
1.6.4.2

