Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZI3NZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZI3NZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZI3NZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:25:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55918 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751605AbZI3NZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:25:10 -0400
Date: Wed, 30 Sep 2009 14:26:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       marcel@holtmann.org
Subject: Bluetooth is very ill in -next
Message-ID: <20090930142636.5366dafe@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Doing "sdptool search DUN" reliably crashes the kernel when using a USB
bluetooth dongle

Language Base Attr List:
  code_ISO639: 0x656e
  encoding:    0x6a
  base_offset: 0x100
Profile Descriptor List:
  "Dialup Networking" (0x1103)
    Version: 0x0100


is as far as it gets

It then explodes

_spin_lock_irqsave
?skb_dequeue
skb_dequeue
skb_queue_purge
l2cap_recv_frame
?__lock_acquire
?__usb_hcd_submit_urb
?__lock_acquire
l2cap_recv_acldata
hci_rx_task
?l2cap_recv_acldata
tasklet_action

reliably.

Alan
