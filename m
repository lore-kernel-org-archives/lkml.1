Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXAaCk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXAaCk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932438AbXAaCk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:40:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34337 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbXAaCk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:40:28 -0500
Date: Tue, 30 Jan 2007 18:37:06 -0800
From: Andrew Morton <akpm@osdl.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Sergey Vlasov <vsu@altlinux.ru>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] VIA IRQ quirk breakage fix
Message-Id: <20070130183706.f0d93103.akpm@osdl.org>
In-Reply-To: <200701301325.58843.jdelvare@suse.de>
References: <45B6A94A.3010006@yahoo.com.au>
	<200701300854.06083.jdelvare@suse.de>
	<20070130144701.e793c222.vsu@altlinux.ru>
	<200701301325.58843.jdelvare@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 13:25:58 +0100
Jean Delvare <jdelvare@suse.de> wrote:

> So here comes the third
> (and hopefully last) iteration of the patch:

argh, it looks like I sent v2 to Linus.

Here's the missing bit.  Please confirm that we want it?


From: Jean Delvare <jdelvare@suse.de>

Add special handling for the VT82C686.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/quirks.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/pci/quirks.c~via-quirk-fix-update drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~via-quirk-fix-update
+++ a/drivers/pci/quirks.c
@@ -661,9 +661,11 @@ static void quirk_via_bridge(struct pci_
 	/* See what bridge we have and find the device ranges */
 	switch (dev->device) {
 	case PCI_DEVICE_ID_VIA_82C686:
-		/* 82C686 is special */
-		via_vlink_dev_lo = 7;
-		via_vlink_dev_hi = 7;
+		/* The VT82C686 is special, it attaches to PCI and can have
+		   any device number. All its subdevices are functions of
+		   that single device. */
+		via_vlink_dev_lo = PCI_SLOT(dev->devfn);
+		via_vlink_dev_hi = PCI_SLOT(dev->devfn);
 		break;
 	case PCI_DEVICE_ID_VIA_8237:
 	case PCI_DEVICE_ID_VIA_8237A:
_

