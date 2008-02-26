Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbYBZNnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbYBZNnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 08:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYBZNn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 08:43:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:33847 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYBZNn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 08:43:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ryF/c04ZhsCJUNwQs8GCsV5c1nsWqiOAt/W1gODQuy62uTFUG/cAJgG2yDY/t1MhwTzNzgx6MDHng4X6jro4IaHq/k/xwjLeMv/CJdof8DTsBfEoKSRt4V0HXFAk1CL4AY2A+Et6XXluZd5Tg4UYOqDhFgay2b6eYpGqM7ARMGA=
Message-ID: <4ac2955e0802260543n7d7e5d81nb590d2bc10648269@mail.gmail.com>
Date: Tue, 26 Feb 2008 19:13:26 +0530
From: "mahendra varman" <mahendravarman15@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: usb detecting only high speed devices only - not detecting low speed devices
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

In a project Iam using 7448 powerpc processor . In that board iam
using ISP 1562 philips PCI based usb controller.
The problem iam facing is in Linux level the usb ports are detecting
only ehci high speed devices(flash mem stick)
 But it is not detecting low speed devices(mouse,keyboard) and
reporting Unlink no irq..Controller probably using wrong irq.

As per ISP 1562 the same interrupt is routed to 3 functions inside one
controller( 2 ohci and 1 ehci)
 The interrupt works for the ehci device ( flash mem stick)
The same interrupt is assigned for ohci function. I removed the flash
stick and inserted an ohci device(mouse)
but iam getting unlink after no IRQ

How the interrupt works for ehci and the same interrupt not working for ohci ?

I can ensure that the IRQ assignment has been done properly as well as
I have enabled necesary configs in menuconfig for ehci and ohci

I tried linux version 2.6.12 , 2.6.16.60 and also 2.6.23  , 2.6.24 ..
In all these iam facing the above issues

Please shed some light to solve the issue

Thanks


Below are some observations
 -----------------------------------------------
BEFORE INSERTING MOUSE
/ # cat /proc/interrupts
           CPU0
 12:         99  tsi108_pic Level     serial
 36:          1  tsi108_PCI_int Level     VMEBus (Tsi148)
  39:          0  tsi108_PCI_int Level     ehci_hcd:usb1,
ohci_hcd:usb2, ohci_hcd :usb3

AFTER INSERTING MOUSE
/ # usb 3-1: new low speed USB device using ohci_hcd and address 2
ohci_hcd 0000:01:04.1: Unlink after no-IRQ?  Controller is probably
using the wrong IRQ.

/ # cat /proc/interrupts
           CPU0
 12:        130  tsi108_pic Level     serial
 36:          1  tsi108_PCI_int Level     VMEBus (Tsi148)
 39:          2  tsi108_PCI_int Level     ehci_hcd:usb1,
ohci_hcd:usb2, ohci_hcd:usb3
