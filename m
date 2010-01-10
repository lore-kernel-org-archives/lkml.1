Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119Ab0AJWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0AJWUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052Ab0AJWUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:20:47 -0500
Received: from kotten8a.marieberg.ac ([213.238.238.22]:53659 "HELO
	iluvatar.nyren.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754036Ab0AJWUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:20:46 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2010 17:20:46 EST
Content-Type: text/plain; charset=iso-8859-1; format=flowed; delsp=yes
Date: Sun, 10 Jan 2010 23:14:25 +0100
To: linux-kernel@vger.kernel.org
Subject: Bug found in ext3 quota enabled fs
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Ralf Nyren" <ralf@nyren.net>
Message-ID: <op.u6b72biaumhi3g@fujje.vpn.nyren.net>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I did an rsync of a remote file to a local ext3 filesystem with journaled
quotas enabled. Got the kernel BUG report below... I was able to reproduce
the error. Let me know if there is any additional info that would help.

Best regards, Ralf


------------[ cut here ]------------
kernel BUG at fs/quota/dquot.c:1398!
invalid opcode: 0000 [#1]
last sysfs file: /sys/class/net/lo/operstate
Modules linked in: dm_snapshot dm_mirror dm_region_hash dm_log it87  
hwmon_vid snd_via82xx snd_ac97_codec ac97_bus snd_pcm sym53c8xx snd_timer  
scsi_transport_spi snd_page_alloc snd_mpu401_uart parport_pc parport  
snd_rawmidi i2c_viapro snd soundcore i2c_core

Pid: 8593, comm: rsync Not tainted (2.6.32.3 #1) To Be Filled By O.E.M.
EIP: 0060:[<c10aaee0>] EFLAGS: 00010246 CPU: 0
EIP is at dquot_transfer+0x550/0x5e0
EAX: c14bd3c0 EBX: f1515f54 ECX: 00000000 EDX: 00000000
ESI: 00000001 EDI: f1515f54 EBP: f1515edc ESP: f1515e80
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rsync (pid: 8593, ti=f1514000 task=f19758e0 task.ti=f1514000)
Stack:
  f19758e0 f0cd73ec f5f2c4d0 f1515eb4 c10aa3e7 00000001 f1c751ac 00000bb4
<0> 00000000 00001000 00000000 f1c751ac f1515ec8 f1515edc 00000000 f1f18c60
<0> 00000000 00000000 f1f18b20 00008a80 f1c751ac f1515f54 f1515f54 f1515eec
Call Trace:
  [<c10aa3e7>] ? dqget+0x147/0x280
  [<c10a7bf6>] ? vfs_dq_transfer+0x86/0xc0
  [<c11032b1>] ? ext3_setattr+0x181/0x1e0
  [<c1278182>] ? cap_inode_need_killpriv+0x32/0x50
  [<c108245d>] ? notify_change+0xed/0x340
  [<c106db8a>] ? chown_common+0x5a/0x70
  [<c106dd26>] ? sys_lchown+0x66/0x80
  [<c1002cb5>] ? syscall_call+0x7/0xb
Code: ff 66 90 e9 0f fe ff ff 8d 76 00 7f 0c 39 4d b8 8d 76 00 0f 82 72 fd  
ff ff b8 0a 00 00 00 90 8d 74 26 00 e9 9d fd ff ff 8d 76 00 <0f> 0b 8d b6  
00 00 00 00 eb f8 8b 79 70 8b 49 74 39 ce 0f 8c 08
EIP: [<c10aaee0>] dquot_transfer+0x550/0x5e0 SS:ESP 0068:f1515e80
---[ end trace 821f95b14922033a ]---


