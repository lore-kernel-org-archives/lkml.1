Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbZJLBJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbZJLBJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 21:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZJLBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 21:09:18 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:65350 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZJLBJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 21:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Wa9hB2JUGvOT0LAcBvrQyROxmc6Rtw0vuCqT1gFmtYUaluNelwOEFhohgmkIc84iS1
         Rpi5XkBhoOt919hCtSrrtKEMnL7OzTkdSXSPDZZGMmqV8DCf820x2MCsQW9402AN048a
         Isy13aQgb+IyPMzroBX/vTXrltiBXIkfH0xVE=
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 07:08:39 +0600
Message-ID: <b9df5fa10910111808p424bba2bu999a7a49f32cc3d0@mail.gmail.com>
Subject: [PATCH -mm]: vbus: Fix section mismatch warnings in pci-bridge.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: ghaskins@novell.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The functions vbus_pci_open, _ioq_init, eventq_init,
vbus_pci_eventq_register are
annoted with __init and referenced from a function __devinit
vbus_pci_probe, which
causes a section mismatch.So annote those functions with __devinit.

 We were warned by the following warnings:

  LD      drivers/vbus/vbus-pcibridge.o
WARNING: drivers/vbus/vbus-pcibridge.o(.devinit.text+0x19e): Section
mismatch in reference from the function vbus_pci_probe() to the
function .init.text:vbus_pci_open()
The function __devinit vbus_pci_probe() references
a function __init vbus_pci_open().
If vbus_pci_open is only used by vbus_pci_probe then
annotate vbus_pci_open with a matching annotation.

WARNING: drivers/vbus/vbus-pcibridge.o(.devinit.text+0x1f4): Section
mismatch in reference from the function vbus_pci_probe() to the
function .init.text:_ioq_init()
The function __devinit vbus_pci_probe() references
a function __init _ioq_init().
If _ioq_init is only used by vbus_pci_probe then
annotate _ioq_init with a matching annotation.

WARNING: drivers/vbus/vbus-pcibridge.o(.devinit.text+0x240): Section
mismatch in reference from the function vbus_pci_probe() to the
function .init.text:eventq_init()
The function __devinit vbus_pci_probe() references
a function __init eventq_init().
If eventq_init is only used by vbus_pci_probe then
annotate eventq_init with a matching annotation.

WARNING: drivers/vbus/vbus-pcibridge.o(.devinit.text+0x45a): Section
mismatch in reference from the function vbus_pci_probe() to the
function .init.text:vbus_pci_eventq_register()
The function __devinit vbus_pci_probe() references
a function __init vbus_pci_eventq_register().
If vbus_pci_eventq_register is only used by vbus_pci_probe then
annotate vbus_pci_eventq_register with a matching annotation.

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/vbus/pci-bridge.c	2009-10-11 23:38:51.000000000 +0600
+++ rakib/drivers/vbus/pci-bridge.c	2009-10-11 23:46:52.000000000 +0600
@@ -478,7 +478,7 @@ event_shmclose(struct vbus_pci_handle_ev

 static struct ioq_notifier eventq_notifier;

-static int __init
+static int __devinit
 eventq_init(int qlen)
 {
 	struct ioq_iterator iter;
@@ -687,7 +687,7 @@ vbus_pci_release(void)
 	vbus_pci.enabled = false;
 }

-static int __init
+static int __devinit
 vbus_pci_open(void)
 {
 	struct vbus_pci_bridge_negotiate params = {
@@ -702,7 +702,7 @@ vbus_pci_open(void)

 #define QLEN 1024

-static int __init
+static int __devinit
 vbus_pci_eventq_register(void)
 {
 	struct vbus_pci_busreg params = {
@@ -720,7 +720,7 @@ vbus_pci_eventq_register(void)
 				   &params, sizeof(params));
 }

-static int __init
+static int __devinit
 _ioq_init(size_t ringsize, struct ioq *ioq, struct ioq_ops *ops)
 {
 	struct shm_signal    *signal = NULL;
