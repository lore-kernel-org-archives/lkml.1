Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbXF0OFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbXF0OFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXF0OF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:05:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbXF0OF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:05:27 -0400
Message-ID: <46826EA3.2020707@anagramm.de>
Date: Wed, 27 Jun 2007 16:05:23 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.21.5 BUG: USB FTDI FT323BM usb exports duplicate symbols
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19kizCaJH+WWLbX+HH5pBVt23lvIF7Tj39vIbj
 hLIzlkxnh4oedP3XuitXIT1ALzlyu/UdS6gXZ43ecJnwSL1hTM
 hdMpVPb+yqsg2Zigl5vBQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Whenever I plug/unplug the FTDI FT232BM USB-RS232 converter, the latest
2.6.21.5 kernel complains:

usb 2-1: USB disconnect, address 7
ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
ftdi_sio 2-1:1.0: device disconnected
usb 3-1: new full speed USB device using ohci_hcd and address 43
usb 3-1: configuration #1 chosen from 1 choice
ftdi_sio 3-1:1.0: FTDI USB Serial Device converter detected
drivers/usb/serial/ftdi_sio.c: Detected FT232BM
usb 3-1: FTDI USB Serial Device converter now attached to ttyUSB0
usbcore: exports duplicate symbol usb_buffer_unmap_sg (owned by kernel)
usbserial: exports duplicate symbol usb_serial_port_softint (owned by kernel)
kobject_add failed for ftdi_sio with -EEXIST, don't try to register things with the same name in the same directory.
Call Trace:
[C4A6DE10] [C0009018] show_stack+0x4c/0x1ac (unreliable)
[C4A6DE50] [C013DF80] kobject_shadow_add+0x160/0x1a4
[C4A6DE70] [C003A250] mod_sysfs_setup+0x28/0xd4
[C4A6DE90] [C003B4BC] sys_init_module+0xfc4/0x149c
[C4A6DF40] [C0002304] ret_from_syscall+0x0/0x3c
usb 3-1: USB disconnect, address 43
ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
ftdi_sio 3-1:1.0: device disconnected
usb 3-1: new full speed USB device using ohci_hcd and address 44
usb 3-1: configuration #1 chosen from 1 choice
ftdi_sio 3-1:1.0: FTDI USB Serial Device converter detected
drivers/usb/serial/ftdi_sio.c: Detected FT232BM
usb 3-1: FTDI USB Serial Device converter now attached to ttyUSB0
usbcore: exports duplicate symbol usb_buffer_unmap_sg (owned by kernel)
usbserial: exports duplicate symbol usb_serial_port_softint (owned by kernel)
kobject_add failed for ftdi_sio with -EEXIST, don't try to register things with the same name in the same directory.
Call Trace:
[C50BFE10] [C0009018] show_stack+0x4c/0x1ac (unreliable)
[C50BFE50] [C013DF80] kobject_shadow_add+0x160/0x1a4
[C50BFE70] [C003A250] mod_sysfs_setup+0x28/0xd4
[C50BFE90] [C003B4BC] sys_init_module+0xfc4/0x149c
[C50BFF40] [C0002304] ret_from_syscall+0x0/0x3c

Is this considered harmful?
Let me know if you need more debugging information.

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
