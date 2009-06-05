Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZFEMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZFEMoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZFEMoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:44:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51399 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZFEMoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:44:04 -0400
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
Date: Fri, 05 Jun 2009 15:44:04 +0300
Message-Id: <1244205844.23533.21.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin,

On Fri, 2009-06-05 at 13:46 +0200, Corentin Chary wrote:
> First, I think a one line
> set_acpi(CM_ASL_CAMERA, 1);
> with a small comment is better. (If it fails, it's because there no
> camera, so we don't mind).

OK, I've included an updated version of the patch.

On Fri, 2009-06-05 at 13:46 +0200, Corentin Chary wrote:
> Anyway, I'm not sure it's a good idea to enable the camera by default.
> It depends how many power the camera is using (when idle). Coud you
> check that (with power top maybe ?).

People who prefer power savings over functional camera can always
disable it. If you look at the amount of "my camera doesn't" work bug
reports, I think it's pretty evident that we should enable it by default
or provide a config option that does it.

That said, I am more than happy to measure this but I need a little bit
more information to get started as I have never used powertop. So what
is it exactly you want me to do?

			Pekka

>From 8a0abd12147c18e8cbc939134af5ae40b44300f0 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 5 Jun 2009 11:30:07 +0300
Subject: [PATCH] eeepc-laptop: enable camera by default

If we leave the camera disabled by default, userspace programs (e.g.
Skype, Cheese) leave the user out in the cold saying that the machine
"has no camera." Therefore, it's better to enable camera by default and
let people who really don't want it just disable the thing.

Cc: <acpi4asus-user@lists.sourceforge.net>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/platform/x86/eeepc-laptop.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 353a898..6a8426f 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -334,6 +334,19 @@ static int eeepc_bluetooth_rfkill_state(void *data, enum rfkill_state *state)
 }
 
 /*
+ * Camera helpers
+ */
+
+static void eeepc_enable_camera(void)
+{
+	/*
+	 * If the following call to set_acpi() fails, it's because there's no
+	 * camera so we can ignore the error.
+	 */
+	set_acpi(CM_ASL_CAMERA, 1);
+}
+
+/*
  * Sys helpers
  */
 static int parse_arg(const char *buf, unsigned long count, int *val)
@@ -996,6 +1009,9 @@ static int __init eeepc_laptop_init(void)
 	result = eeepc_hwmon_init(dev);
 	if (result)
 		goto fail_hwmon;
+
+	eeepc_enable_camera();
+
 	/* Register platform stuff */
 	result = platform_driver_register(&platform_driver);
 	if (result)
-- 
1.5.6.3



