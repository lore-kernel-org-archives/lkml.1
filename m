Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYFEJj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYFEJj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYFEJjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:39:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:36724 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYFEJjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q6wkyELqyExT0/1qAbx3awgLe+9mikieTGBR+oBpM/+NbSv5/PCtkTmvrwyOKoRUHQ
         enX+AR49PSfcKWvaYfz8ERH3r/rMYVxpNpJqL6hBx5BnHd4zmTRKeJj+PEbFa0igDwTD
         CVhMJgwFAdZthDrjirhBOzsbR/BOLMtJHtuic=
Message-ID: <35fbaa3e0806050239y5987fc33rd349be8d07bc1262@mail.gmail.com>
Date: Thu, 5 Jun 2008 12:39:46 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCH resend] Adding dummy release functions to avoid warnings.
Cc: lkml <linux-kernel@vger.kernel.org>, devzero@web.de, jsun@junsun.net,
       dwmw2@infradead.org, protasnb@gmail.com
In-Reply-To: <1208306056.15140.13.camel@pcvitaliy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208306056.15140.13.camel@pcvitaliy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Natalie reported that patch wasn't accepted.
Please check this out. If I need to correct it somehow then pls let me know.

V.

---------- Forwarded message ----------
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Wed, Apr 16, 2008 at 3:34 AM
Subject: [PATCH] Adding dummy release functions to avoid warnings.
To: linux-kernel@vger.kernel.org, devzero@web.de, jsun@junsun.net,
dwmw2@infradead.org



Subject: [PATCH] Adding dummy release functions to avoid warnings.

From: Vitaliy Ivanov <vitalivanov@gmail.com>

Trivial fix for #9690.
Added simple release functions that doing nothing.
Not sure whether we can leave it as is or to rework using
platform_device helpers like platform_device_alloc.
This approach is used in many drivers.


Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

--

 drivers/mtd/maps/physmap.c |    6 ++++++
 drivers/video/hgafb.c      |   10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index bc4649a..5bdbd04 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -264,11 +264,17 @@ static struct resource physmap_flash_resource = {
       .flags          = IORESOURCE_MEM,
 };

+/* Fake release func.*/
+static void physmap_flash_release(struct device *dev)
+{
+}
+
 static struct platform_device physmap_flash = {
       .name           = "physmap-flash",
       .id             = 0,
       .dev            = {
               .platform_data  = &physmap_flash_data,
+               .release        = physmap_flash_release,
       },
       .num_resources  = 1,
       .resource       = &physmap_flash_resource,
diff --git a/drivers/video/hgafb.c b/drivers/video/hgafb.c
index fb9e672..8707115 100644
--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -623,8 +623,16 @@ static struct device_driver hgafb_driver = {
       .remove = hgafb_remove,
 };

+/* Fake release func.*/
+static void hgafb_device_release(struct device *dev)
+{
+}
+
 static struct platform_device hgafb_device = {
-       .name = "hgafb",
+       .name   = "hgafb",
+       .dev    = {
+               .release = hgafb_device_release,
+       },
 };

 static int __init hgafb_init(void)
