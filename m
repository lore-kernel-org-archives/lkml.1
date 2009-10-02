Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZJBFbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZJBFbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbZJBFbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:31:47 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:56306 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbZJBFbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=YsVYOuk7zmOqwqsNqiCqc8YQfNAouMlionAjv4vXDEVhz/0OKCbvY++gzYuykt5D2h
         Mco2/LyfihlDTx0wa20Gp4Gf26giuXRK9M4Qf88XXR5WWb8kKsgqZVS8v1fr9mq7TW+q
         aEv2NZhdoPeFmBS0Rq3gjbODGJeSStCQhXJ9c=
MIME-Version: 1.0
Date: Fri, 2 Oct 2009 11:31:51 +0600
Message-ID: <b9df5fa10910012231u38f49eeeoe1d0bcc9eafd53d6@mail.gmail.com>
Subject: [PATCH] eeepc_laptop: Properly annote eeepc_enable_camera().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: acpi4asus-user@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: corentincj@iksaif.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Currenlty the annotation for function eeepc_enable_camera() is
__init, and refers to a function eeepc_hotk_add() which is non-init.
Use __devinit for both functions which is
 more appropriate and fixes a section mismatch warning.

 We were warned by the following warning:

  LD      drivers/platform/x86/built-in.o
WARNING: drivers/platform/x86/built-in.o(.text+0x12e1): Section
mismatch in reference from the function eeepc_hotk_add() to the
function .init.text:eeepc_enable_camera()
The function eeepc_hotk_add() references
the function __init eeepc_enable_camera().
This is often because eeepc_hotk_add lacks a __init
annotation or the annotation of eeepc_enable_camera is wrong.

----
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/platform/x86/eeepc-laptop.c	2009-09-28
12:05:21.000000000 +0600
+++ rakib/drivers/platform/x86/eeepc-laptop.c	2009-09-29
23:40:00.000000000 +0600
@@ -350,7 +350,7 @@ static const struct rfkill_ops eeepc_rfk
 	.set_block = eeepc_rfkill_set,
 };

-static void __init eeepc_enable_camera(void)
+static void __devinit eeepc_enable_camera(void)
 {
 	/*
 	 * If the following call to set_acpi() fails, it's because there's no
@@ -1189,7 +1189,7 @@ static int eeepc_input_init(struct devic
 	return 0;
 }

-static int eeepc_hotk_add(struct acpi_device *device)
+static int __devinit eeepc_hotk_add(struct acpi_device *device)
 {
 	struct device *dev;
 	int result;
