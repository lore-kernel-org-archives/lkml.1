Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZJCGYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZJCGYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 02:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbZJCGYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 02:24:50 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:62985 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZJCGYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 02:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nx2OAi5ihYmTlNemnXhiFfIHqj77qCwu0lQLEibYdj5cJQbFxcJTJoQMlKEu3/iKlb
         FjEfd2d3rtRxbsKpKa6L+qcIpf8DgkdWgVhTMqMx/zs1ZIt2aJmWDfyIi02+sH19OcNx
         fs6mdsX6X161MsjCuupqCbkkkkHef1kXMiFVQ=
MIME-Version: 1.0
Date: Sat, 3 Oct 2009 12:24:53 +0600
Message-ID: <b9df5fa10910022324u1d91b4d0oe051ef45dd347cbc@mail.gmail.com>
Subject: [Resend][PATCH] eeepc-laptop: Properly annote eeepc_enable_camera().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: corentincj@iksaif.net
Cc: acpi4asus-user@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Currently the annotation for function eeepc_enable_camera() is
__init, and refers to a
function eeepc_hotk_add() which is non-init. Use __devinit for both
functions which is
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

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/platform/x86/eeepc-laptop.c	2009-10-03
12:44:40.000000000 +0600
+++ rakib/drivers/platform/x86/eeepc-laptop.c	2009-10-03
12:48:42.000000000 +0600
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
