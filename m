Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbXGIKIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbXGIKIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXGIKIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:08:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40456 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbXGIKIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:08:34 -0400
Date: Mon, 9 Jul 2007 11:14:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-ID: <20070709111431.2fd3fba9@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Are the shortlogs useful - yes .. they catch what appear to be mistakes

Specifically: What happened to the aacraid ioctl security fix ? Did someone decide it
wasn't needed or did it get lost somewhere on the way ?

While this looks scary the only obvious exploit cases are where the user can
open a device level file on an AACraid. Very few people put scanners or CD
devices on one so the actual impact is probably minimal.

Alan

--

Signed-off-by: Alan Cox <alan@redhat.com>

--- drivers/scsi/aacraid/linit.c~	2007-07-09 10:51:55.653223304 +0100
+++ drivers/scsi/aacraid/linit.c	2007-07-09 10:51:55.653223304 +0100
@@ -453,6 +453,8 @@
 static int aac_ioctl(struct scsi_device *sdev, int cmd, void __user * arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 	return aac_do_ioctl(dev, cmd, arg);
 }
 
@@ -645,6 +647,8 @@
 static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 
