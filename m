Return-Path: <linux-kernel-owner+w=401wt.eu-S1030489AbXCLQLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030489AbXCLQLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXCLQLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:11:22 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:59576 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030489AbXCLQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:11:21 -0400
Message-ID: <45F57B80.5000203@gmail.com>
Date: Mon, 12 Mar 2007 17:10:40 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: stern@rowland.harvard.edu, linux-usb-devel@lists.sourceforge.net
Subject: rmmod uhci_hcd -> BUG: atomic counter underflow
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

After rmmoding of uhci_hcd on fresh booted 2.6.21-rc3-mm2 I got this:

BUG: atomic counter underflow at:
  [<c0104f0b>] show_trace_log_lvl+0x1a/0x30
  [<c01055f3>] show_trace+0x12/0x14
  [<c010567a>] dump_stack+0x16/0x18
  [<c01dc41b>] kref_put+0x4d/0xb2
  [<c01db754>] kobject_put+0x14/0x16
  [<c01db8a3>] kobject_unregister+0x22/0x25
  [<c024c987>] bus_remove_driver+0x75/0x82
  [<c024d3b8>] driver_unregister+0xb/0x18
  [<c01e7020>] pci_unregister_driver+0x13/0x73
  [<f88dbbd9>] uhci_hcd_cleanup+0xd/0x2d [uhci_hcd]
  [<c013fb69>] sys_delete_module+0x133/0x195
  [<c0103fe0>] syscall_call+0x7/0xb
  =======================

Note, that this is connected:
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 004: ID 0458:004c KYE Systems Corp. (Mouse Systems) Slimstar 
Pro Keyboard
Bus 002 Device 003: ID 04b4:2050 Cypress Semiconductor Corp.
Bus 002 Device 002: ID 045e:00f0 Microsoft Corp.
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 001: ID 0000:0000
Bus 005 Device 001: ID 0000:0000

What other info do you want me to post?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

