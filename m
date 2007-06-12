Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbXFLOEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbXFLOEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbXFLOEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:04:34 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:20122 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbXFLOE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:04:29 -0400
X-Greylist: delayed 2544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 10:04:29 EDT
Date: Tue, 12 Jun 2007 15:21:56 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: linux-kernel@vger.kernel.org
Subject: [2.6.21.4]: possible recursive locking detected
Message-ID: <Pine.BSO.4.63.0706121515470.5377@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-456270571-1181654516=:5377"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-456270571-1181654516=:5377
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT


I found below call trace today morning in dmesg output on one of my test
computer:

=============================================
[ INFO: possible recursive locking detected ]
2.6.21.4-2.1 #1
---------------------------------------------
usb-storage/1806 is trying to acquire lock:
  (&(us->dev_mutex)){--..}, at: [<c05f28a2>] mutex_lock+0x1c/0x1f

but task is already holding lock:
  (&(us->dev_mutex)){--..}, at: [<c05f28a2>] mutex_lock+0x1c/0x1f

other info that might help us debug this:
1 lock held by usb-storage/1806:
  #0:  (&(us->dev_mutex)){--..}, at: [<c05f28a2>] mutex_lock+0x1c/0x1f

stack backtrace:
  [<c04064d4>] show_trace_log_lvl+0x1a/0x2f
  [<c0406a7f>] show_trace+0x12/0x14
  [<c0406afa>] dump_stack+0x16/0x18
  [<c043fb88>] __lock_acquire+0x116/0xb4b
  [<c044097e>] lock_acquire+0x56/0x6f
  [<c05f2721>] __mutex_lock_slowpath+0xe5/0x24a
  [<c05f28a2>] mutex_lock+0x1c/0x1f
  [<f89981d3>] storage_pre_reset+0xe/0x10 [usb_storage]
  [<c0552e3d>] usb_reset_composite_device+0x9c/0x124
  [<f8996888>] usb_stor_port_reset+0x34/0x57 [usb_storage]
  [<f899778e>] usb_stor_invoke_transport+0x255/0x293 [usb_storage]
  [<f89967b9>] usb_stor_transparent_scsi_command+0x8/0xa [usb_storage]
  [<f899833e>] usb_stor_control_thread+0x136/0x1b7 [usb_storage]
  [<c0435edf>] kthread+0xb3/0xdc
  [<c0406177>] kernel_thread_helper+0x7/0x10
  =======================
usb 1-1.2: reset high speed USB device using ehci_hcd and address 5

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-456270571-1181654516=:5377--
