Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYCCK4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYCCK4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYCCK4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:56:21 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36927 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYCCK4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:56:20 -0500
Cc: linux-bluetooth@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
Message-Id: <82FF3AE0-C5AB-4CDB-B065-EF6025FA2608@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
In-Reply-To: <a8e1da0803021741x7c8fc880g9259196adb062fd9@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: hci reset on init
Date: Mon, 3 Mar 2008 11:56:09 +0100
References: <a8e1da0803021741x7c8fc880g9259196adb062fd9@mail.gmail.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> Recently, I find my usb bluetooth dongle doesn't work after reboot  
> or resume.
>
> Kernel report (with bluetooth mouse active):
>
> Feb 15 16:54:32 darkstar kernel: hci_acldata_packet: hci0 ACL packet  
> for unknown
> connection handle 43
> Feb 15 16:54:34 darkstar last message repeated 124 times
>
> I fixed it by adding HCI_RESET to CSR usb id:
>        { USB_DEVICE(0x0a12, 0x0001), .driver_info = HCI_CSR | 
> HCI_RESET},
>
> Maybe you have known that there's other reports about this on
> bluetooth list as well.
>
> Most of the ids in hci_usb.c have the HCI_RESET option set.  Does we
> need to do this automaticly?  I want to know whether sending reset
> request on init in hci_core.c is better, or at least the btusb driver
> need these porting.
>
> What's your opinion?

this is a clear NAK since you gonna break all old CSR based dongles.  
Within the Bluetooth 1.0b and 1.1 specification there was an issues  
with if HCI_Reset should only reset the Bluetooth internals or also  
the transport. So issuing HCI_Reset on an old dongle will cause an USB  
reset.

The solution is to find the build id when CSR produced correct  
firmware and set the HCI_RESET quirk based on that. I meant to do this  
for a long time, but so far never got around to inquiry the correct  
build id where this got fixed.

Regards

Marcel

