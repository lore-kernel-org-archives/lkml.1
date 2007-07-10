Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbXGJHRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbXGJHRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXGJHQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:16:55 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:58427 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751769AbXGJHQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:16:54 -0400
Message-id: <13055248471022532464@wsc.cz>
In-reply-to: <7wlkdp8yoe.fsf@gmdev.webwayone.co.uk>
From: Jiri Slaby <jirislaby@gmail.com>
To: Graham Murray <gmurray@webwayone.co.uk>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Specialix SX cards not detected in kernels >=2.6.20
Date: Tue, 10 Jul 2007 09:17:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Graham Murray wrote:
> There were multiple changes to the char/sx.c driver in kernel 2.6.20. In
> kernels 2.6.19 and earlier, the SX multiport serial card works OK, but
> in 2.6.20 and later the driver does not seemt to detect the presence of
> the card. 
> 
> I have enabled sx_debug=-1 and added some printk statements to try and
> detect why the card is not detected. These show that sx_init is entered
> and within that function the call to pci_register_driver returns 0. I do
> not see any other routines in the driver being entered either at startup
> (when the module is loaded, which indicates that the system recognises
> the PCI ID) or when running 'modprobe sx'. In particular, sx_pci_probe()
> is never entered.
> 
> lspci -vv for the card
> 
>  10:01.0 Communication controller: Specialix Research Ltd. PCI_9050
> 	Subsystem: Specialix Research Ltd. Unknown device 0300
[...]
> Where should I look for and how should I obtain further debug to
> determine where the problem lies?

In switched ids. Could you try the patch below?

--

sx, switch subven and subid values

This is because card is not found.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fdf11b85b74221d25a3abf38a9ebf947959d0fe1
tree 289b5f58dc2774019ed3f3bedef99344be76d7bc
parent 10d4605a5a9d86c467b78f602ef43067da5d9dfe
author Jiri Slaby <jirislaby@gmail.com> Tue, 10 Jul 2007 09:13:22 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Jul 2007 09:13:22 +0200

 drivers/char/sx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 1da92a6..85a2328 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2721,9 +2721,9 @@ static void __devexit sx_pci_remove(struct pci_dev *pdev)
    its because the standard requires it. So check for SUBVENDOR_ID. */
 static struct pci_device_id sx_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
-		.subvendor = 0x0200,.subdevice = PCI_ANY_ID },
+		.subvendor = PCI_ANY_ID, .subdevice = 0x0200 },
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
-		.subvendor = 0x0300,.subdevice = PCI_ANY_ID },
+		.subvendor = PCI_ANY_ID, .subdevice = 0x0300 },
 	{ 0 }
 };
 
