Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZCFSii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZCFSii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbZCFSiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:38:10 -0500
Received: from mx48.mail.ru ([94.100.176.62]:21657 "EHLO mx48.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbZCFSiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:38:09 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
To: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 06 Mar 2009 21:37:50 +0300
References: <20090306003941.GA32403@srcf.ucam.org> <20090306005234.GA32539@srcf.ucam.org>
User-Agent: KNode/0.99.01
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Lfevu-000MzF-00.arvidjaar-mail-ru@mx48.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:

> Calling the ENAB method on Toshiba laptops results in notifications
> being sent when laptop hotkeys are pressed. This patch simply calls that
> method and sets up an input device if it's successful.
>     
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 

Works on my Toshiba Portege 4000. I tried to enable it directly in keyboard  controller using 
information from Toshiba Linux pages but it failed. Thank you!

Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>

Trivial cleanup below. Also the patch should remove /proc/acpi/toshiba/keys. It will consume hot keys 
as soon as they are pressed, so user space watching this file has very little chances to ever see 
them.

---

Subject: [PATCH] Trivial fixes to enable Toshiba keyboard patch
From: Andrey Borzenkov <arvidjaar@mail.ru>

Fix type of third parameter of toshiba_acpi_notify.
Remove extraneous white space in function invocation.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

---

 drivers/platform/x86/toshiba_acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 604f9fa..c334007 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -793,7 +793,7 @@ static int toshiba_acpi_setkeycode(struct input_dev *dev, int scancode,
 	return -EINVAL;
 }
 
-static void toshiba_acpi_notify(acpi_handle handle, u32 event, void **data)
+static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *data)
 {
 	u32 hci_result, value;
 	struct key_entry *key;
@@ -851,7 +851,7 @@ static int toshiba_acpi_setup_keyboard(char *device)
 		return -ENODEV;
 	}
 
-	status = acpi_install_notify_handler (handle, ACPI_DEVICE_NOTIFY,
+	status = acpi_install_notify_handler(handle, ACPI_DEVICE_NOTIFY,
 					      toshiba_acpi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
 		printk(MY_INFO "Unable to install hotkey notification\n");
