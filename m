Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbYCCBlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbYCCBlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 20:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYCCBlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 20:41:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:52598 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbYCCBlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 20:41:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iK6lPulDVWNAdFmhASGLRUOgGqE3qIRXxFEIJsGkU6NDi6L/M973sEQEkfuz+2ykD92SwvB3UyhfNUmQqqWberxnqeiXydtUd/BsTiVs41p8d28Su81ZRkfNmYYGz/9ZEpH9t165biQDScJa4yEPUYykTf2GRbzknPepxL9eqrM=
Message-ID: <a8e1da0803021741x7c8fc880g9259196adb062fd9@mail.gmail.com>
Date: Mon, 3 Mar 2008 09:41:03 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: hci reset on init
Cc: linux-bluetooth@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, marcel

Recently, I find my usb bluetooth dongle doesn't work after reboot or resume.

Kernel report (with bluetooth mouse active):

Feb 15 16:54:32 darkstar kernel: hci_acldata_packet: hci0 ACL packet for unknown
 connection handle 43
Feb 15 16:54:34 darkstar last message repeated 124 times

I fixed it by adding HCI_RESET to CSR usb id:
        { USB_DEVICE(0x0a12, 0x0001), .driver_info = HCI_CSR |HCI_RESET},

Maybe you have known that there's other reports about this on
bluetooth list as well.

Most of the ids in hci_usb.c have the HCI_RESET option set.  Does we
need to do this automaticly?  I want to know whether sending reset
request on init in hci_core.c is better, or at least the btusb driver
need these porting.

What's your opinion?

Regards
dave
