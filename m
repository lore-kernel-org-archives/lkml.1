Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZJGKuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZJGKuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbZJGKuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:50:54 -0400
Received: from fr.prnet.org ([91.121.181.205]:48427 "EHLO fr.prnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758860AbZJGKux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:50:53 -0400
X-Greylist: delayed 749 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 06:50:53 EDT
Message-ID: <77ec4e85de9241d16244287e270a5244.squirrel@www.prnet.org>
Date: Wed, 7 Oct 2009 12:37:45 +0200
Subject: 2.6.31.2 : error when ending apcupsd
From: admin@prnet.org
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With kernel 2.6.31.2 I get the following error when I ending apcupsd:

Oct  6 21:00:46 server apcupsd[5238]: apcupsd exiting, signal 15
Oct  6 21:00:46 server BUG: unable to handle kernel paging request at
ffff880130a6d858
Oct  6 21:00:46 server IP: [<ffffffff8124ba55>]
tty_port_close_start+0xc5/0x1d0
Oct  6 21:00:46 server PGD 1002063 PUD 14067 PMD 0
Oct  6 21:00:46 server Oops: 0002 [#1] PREEMPT SMP
Oct  6 21:00:46 server last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sdb/size
Oct  6 21:00:46 server CPU 2
Oct  6 21:00:46 server Modules linked in: capifs nvidia(P) [last unloaded:
kernelcapi]
Oct  6 21:00:46 server Pid: 5238, comm: apcupsd Tainted: P          
2.6.31.2server
#1 P5QL-E
Oct  6 21:00:46 server RIP: 0010:[<ffffffff8124ba55>]  [<ffffffff8124ba55>]
tty_port_close_start+0xc5/0x1d0
Oct  6 21:00:46 server RSP: 0018:ffff88012e3abdb8  EFLAGS: 00010046
Oct  6 21:00:46 server RAX: ffff880130a6d858 RBX: ffff88012f90e900 RCX:
0000000000000000
Oct  6 21:00:46 server RDX: 0000000000001717 RSI: 0000000000000000 RDI:
ffff88012f90e900
Oct  6 21:00:46 server RBP: ffff88012fa6d808 R08: 0000000000000000 R09:
0000000000000000
Oct  6 21:00:46 server R10: 0000000000000000 R11: 0000000000000206 R12:
ffff88012e366000
Oct  6 21:00:46 server R13: ffff88012fa6d818 R14: 0000000000000296 R15:
0000000000000000
Oct  6 21:00:46 server FS:  00007ffecc5ec6f0(0000) GS:ffff880028054000(0000)
knlGS:0000000000000000
Oct  6 21:00:46 server CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct  6 21:00:46 server CR2: ffff880130a6d858 CR3: 000000012e397000 CR4:
00000000000006e0
Oct  6 21:00:46 server DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
Oct  6 21:00:46 server DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
Oct  6 21:00:46 server Process apcupsd (pid: 5238, threadinfo
ffff88012e3aa000, task
ffff88012fa0d910)
Oct  6 21:00:46 server Stack:
Oct  6 21:00:46 server ffff88012e366000 ffff88012f90e900 ffff88012fa6d808
ffff88012fa6d800
Oct  6 21:00:46 server <0> 0000000000000000 ffffffff81305932 0000000000000292
ffff88012e366000
Oct  6 21:00:46 server <0> ffff88012f90e900 0000000000000000 ffff88012f90e900
ffffffff81244d98
Oct  6 21:00:46 server Call Trace:
Oct  6 21:00:46 server [<ffffffff81305932>] ? serial_close+0x72/0xe0
Oct  6 21:00:46 server [<ffffffff81244d98>] ? tty_release_dev+0x198/0x590
Oct  6 21:00:46 server [<ffffffff810afc3f>] ? vfs_ioctl+0x2f/0xb0
Oct  6 21:00:46 server [<ffffffff812451a1>] ? tty_release+0x11/0x20
Oct  6 21:00:46 server [<ffffffff810a27ad>] ? __fput+0xcd/0x1e0
Oct  6 21:00:46 server [<ffffffff8109ef2b>] ? filp_close+0x5b/0x90
Oct  6 21:00:46 server [<ffffffff8109f011>] ? sys_close+0xb1/0x120
Oct  6 21:00:46 server [<ffffffff8100b3ab>] ? system_call_fastpath+0x16/0x1b
Oct  6 21:00:46 server Code: 18 4c 8b 74 24 20 48 83 c4 28 c3 0f 1f 00 8b
75 18 83
fe 01 0f 85 f3 00 00 00 ff 4d 18 8b 75 18 85 f6 75 a9 48 8d 85 50 00 00 01
<f0> 80
8d 50 00 00 01 01 41 80 8c 24 fc 01 00 00 20 4c 89 f6 4c
Oct  6 21:00:46 server RIP  [<ffffffff8124ba55>]
tty_port_close_start+0xc5/0x1d0
Oct  6 21:00:46 server RSP <ffff88012e3abdb8>
Oct  6 21:00:46 server CR2: ffff880130a6d858
Oct  6 21:00:46 server ---[ end trace ed2ac2b5c302fe3c ]---
Oct  6 21:00:46 server note: apcupsd[5238] exited with preempt_count 2

With 2.6.31.1 everything worked flawlessly.
I use an usb to serial converter, here the output from lspci -v for the
converter:

Bus 006 Device 002: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x067b Prolific Technology, Inc.
  idProduct          0x2303 PL2303 Serial Port
  bcdDevice            4.00
  iManufacturer           1 Prolific Technology Inc.
  iProduct                2 USB-Serial Controller D
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

Thanks in advance
Bye,
David Arendt

