Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYKLPk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYKLPk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYKLPkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:40:14 -0500
Received: from 30.mail-out.ovh.net ([213.186.62.213]:46160 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752811AbYKLPkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:40:12 -0500
Message-ID: <491AF8D1.4060106@neotion.com>
Date: Wed, 12 Nov 2008 16:40:01 +0100
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: hjk@linutronix.de
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] uio: add ioctl callback
X-Enigmail-Version: 0.95.7
OpenPGP: id=1166F485
Content-Type: multipart/mixed;
 boundary="------------050703040906070006040507"
X-Ovh-Tracer-Id: 17930800443148104849
X-Ovh-Remote: 82.236.40.173 (sop06-1-82-236-40-173.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050703040906070006040507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Add an ioctl callback for uio devices.

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
---

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 2d2440c..38044fb 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -385,6 +385,18 @@ static unsigned int uio_poll(struct file *filep,
poll_table *wait)
     return 0;
 }
=20
+static int uio_ioctl(struct inode *inode, struct file *filep,
+            unsigned int cmd, unsigned long arg)
+{
+    struct uio_listener *listener =3D filep->private_data;
+    struct uio_device *idev =3D listener->dev;
+
+    if (idev->info->ioctl)
+        return idev->info->ioctl(idev->info, cmd, arg);
+
+    return -ENOSYS;
+}
+
 static ssize_t uio_read(struct file *filep, char __user *buf,
             size_t count, loff_t *ppos)
 {
@@ -590,6 +602,7 @@ static const struct file_operations uio_fops =3D {
     .mmap        =3D uio_mmap,
     .poll        =3D uio_poll,
     .fasync        =3D uio_fasync,
+    .ioctl        =3D uio_ioctl,
 };
=20
 static int uio_major_init(void)
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index cdf338d..e44e89b 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -68,6 +68,8 @@ struct uio_info {
     int (*open)(struct uio_info *info, struct inode *inode);
     int (*release)(struct uio_info *info, struct inode *inode);
     int (*irqcontrol)(struct uio_info *info, s32 irq_on);
+    int (*ioctl)(struct uio_info *info, unsigned int cmd,
+            unsigned long arg);
 };
=20
 extern int __must_check

--------------050703040906070006040507
Content-Type: text/x-vcard; charset=utf-8;
 name="narmstrong.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="narmstrong.vcf"

begin:vcard
fn:Neil Armstrong
n:Armstrong;Neil
org:Neotion;Neotion Sophia Antipolis
adr:;;;Sophia Antipolis;;;France
email;internet:narmstrong@neotion.com
title:Embedded Linux Software Engineer
tel;cell:0667474169
note:PGP 0x1166F485
x-mozilla-html:FALSE
url:http://www.neotion.com
version:2.1
end:vcard


--------------050703040906070006040507--
