Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYISSxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYISSxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYISSxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:53:44 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:45323 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYISSxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:53:44 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Fri, 19 Sep 2008 20:53:36 +0200
User-Agent: KMail/1.9.5
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809192005.12068.stefan.bauer@cs.tu-chemnitz.de> <200809192026.21107.j@jannau.net>
In-Reply-To: <200809192026.21107.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809192053.36760.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 7a8bfbfb0f841b0156073f42c525b1a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2008 20:26, Janne Grunau wrote:
> On Friday 19 September 2008 20:05:11 Stefan Bauer wrote:
> > Thank you for keeping me up to date, here are my test results with
> > todays (36e60bd457588b2a2fd37e0c1d0652a9fe214d85) git:
> >
> > - But lircd crashes immediately every time irexec/irw tries to
> > connect:
> >
> > BUG: unable to handle kernel NULL pointer dereference at 0000000c
>
> not necessary, it is
> commit bc2039245c6390bd414a61c9395604c4155a58c6
> Author: Janne Grunau <j@jannau.net>
> Date:   Thu Sep 18 20:49:19 2008 +0200
>
>     reimplement lirc_buffer as kfifo wrapper

Thank you for pointing me, but bc2039245c6390bd414a61c9395604c4155a58c6~1 
(lirc_streamzap can use lirc_buffer_clear) also crashes lircd when irexec is 
started.

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c01118ce>] try_to_wake_up+0x16/0x7c
*pde = 00000000 
Oops: 0000 [#1] 
Modules linked in: lirc_serial lirc_dev ves1820 arc4 ecb crypto_blkcipher 
cryptomgr crypto_algapi rt61pci rt2x00pci rt2x00lib led_class dvb_ttpci 
saa7146_vv saa7146 mac80211 videobuf_dma_sg ehci_hcd uhci_hcd videobuf_core 
videodev v4l1_compat ttpci_eeprom cfg80211 eeprom_93cx6

Pid: 2939, comm: lircd Not tainted (2.6.27-rc5 #7)
EIP: 0060:[<c01118ce>] EFLAGS: 00010046 CPU: 0
EIP is at try_to_wake_up+0x16/0x7c
EAX: c04091c0 EBX: 0000000f ECX: 00000000 EDX: c3e85e98
ESI: c04091c0 EDI: 00000000 EBP: 00000000 ESP: c3e85e98
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process lircd (pid: 2939, ti=c3e84000 task=c3e866c0 task.ti=c3e84000)
Stack: 00000246 c6a16000 00000000 c691905c c6bed400 cadc05b3 00000000 c6a1607c 
       c014e15c 00000000 c6bed400 c691905c 00000000 c014e09b c014b052 c78c2a00 
       c774c180 c3e85f14 c6bed400 c3e85f14 00000003 c014b156 c6bed400 00000000 
Call Trace:
 [<cadc05b3>] irctl_open+0xdd/0x13c [lirc_dev]
 [<c014e15c>] chrdev_open+0xc1/0xf6
 [<c014e09b>] chrdev_open+0x0/0xf6
 [<c014b052>] __dentry_open+0xf2/0x1da
 [<c014b156>] nameidata_to_filp+0x1c/0x2c
 [<c01544ae>] do_filp_open+0x28b/0x545
 [<c015bc37>] alloc_fd+0x46/0xad
 [<c014ae8d>] do_sys_open+0x42/0xb6
 [<c014af45>] sys_open+0x1e/0x23
 [<c010297d>] sysenter_do_call+0x12/0x25
 [<c02f0000>] ioctl_standard_iw_point+0x12d/0x200
 =======================
Code: 00 00 00 00 5b 5e 5f c3 53 9c 5b fa e8 bb ff ff ff 53 9d 5b c3 55 57 89 
c7 56 53 89 d3 83 ec 04 89 e2 31 ed e8 3a fd ff ff 89 c6 <8b> 07 85 d8 74 41 
83 7f 48 00 75 25 31 c0 66 bd 01 00 e8 ba 40 
EIP: [<c01118ce>] try_to_wake_up+0x16/0x7c SS:ESP 0068:c3e85e98
---[ end trace 344ec27be5d90ccf ]---


Regards,
Stefan
