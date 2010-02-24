Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0BXNZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 08:25:34 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:33793 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab0BXNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 08:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JJL9ugTD2yYJbduV6szqftA/B32j+1/UwXafxDrldVPWlH9EcEXdxoeY+8ChPvlLTX
         B1g0WGxFjFGRM7iNoEbaUUWzODlQaoSX8eBGHkRWXkV0xOtsatxRiD5PNjfwM/4GEIqq
         i5HhC0UG77+1Nyoa8Yf3FTyJIbhf6kaf/fTLU=
MIME-Version: 1.0
Date: Wed, 24 Feb 2010 14:25:31 +0100
Message-ID: <c8e400c21002240525n68f9768ck7a07f6f659ffc88c@mail.gmail.com>
Subject: kernel bug?
From: "saraguato@gmail.com" <saraguato@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am totally stumped as to whom to send the report, so i sent to this address

Problem:
System crash. Some proccess are freezes, some proccess continue ok. I
have to force a hardware reboot.

Keyworkds:
    kernel, nfs

Kernel version:
    Ubuntu 9.04 jaunty, kernel version:Linux la16-cgen-dev
2.6.28-18-generic #59-Ubuntu SMP Thu Jan 28 01:23:03 UTC 2010 i686
GNU/Linux

Descripcion:
    I launched a program during all the night.This program share a
loop device with network block devices.  This loop device is assigned
to a file located in a nfs directory. The program is a server which
share and unshare continually, the client work on shared network block
device when it is shared.
At 7:41 on morning, cron launch some proccess and my server program is
freezed.  A part of the syslog:


Feb 24 07:39:21 la16-cgen-dev nbd_server[23072]: Disconnect request received.
Feb 24 07:39:21 la16-cgen-dev nbd_server[23035]: Child exited with 0
Feb 24 07:39:45 la16-cgen-dev nbd_server[23242]: connect from
127.0.0.1, assigned file is /dev/loop0
Feb 24 07:39:45 la16-cgen-dev nbd_server[23242]: Can't open
authorization file /etc/nbd-server/allow (No such file or directory).
Feb 24 07:39:45 la16-cgen-dev nbd_server[23242]: Authorized client
Feb 24 07:39:45 la16-cgen-dev nbd_server[23277]: Starting to serve
Feb 24 07:39:45 la16-cgen-dev nbd_server[23277]: Size of exported
file/device is 209715200


[The above pattern is repeated all night. Now comes the problem when
cron launch some program]

Feb 24 07:40:01 la16-cgen-dev /USR/SBIN/CRON[23285]: (root) CMD ([ -x
/usr/sbin/update-motd ] && /usr/sbin/update-motd 2>/dev/null)
Feb 24 07:40:31 la16-cgen-dev nbd_server[23277]: Disconnect request received.
Feb 24 07:40:31 la16-cgen-dev nbd_server[23242]: Child exited with 0
Feb 24 07:40:56 la16-cgen-dev nbd_server[23576]: connect from
127.0.0.1, assigned file is /dev/loop0
Feb 24 07:40:56 la16-cgen-dev nbd_server[23576]: Can't open
authorization file /etc/nbd-server/allow (No such file or directory).
Feb 24 07:40:56 la16-cgen-dev nbd_server[23576]: Authorized client
Feb 24 07:40:56 la16-cgen-dev nbd_server[23611]: Starting to serve
Feb 24 07:40:56 la16-cgen-dev nbd_server[23611]: Size of exported
file/device is 209715200
Feb 24 07:41:42 la16-cgen-dev nbd_server[23611]: Disconnect request received.
Feb 24 07:41:42 la16-cgen-dev nbd_server[23576]: Child exited with 0
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.558463] ------------[
cut here ]------------
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.558733] kernel BUG at
/build/buildd/linux-2.6.28/fs/nfs/write.c:252!
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.558805] invalid opcode:
0000 [#1] SMP
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.558879] last sysfs
file: /sys/kernel/uevent_seqnum
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.559160] Dumping ftrace buffer:
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.559360]    (ftrace buffer empty)
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.559490] Modules linked
in: af_key sha256_generic aes_i586 aes_generic cbc binfmt_misc bridge
stp bnep input_polldev video output nfs lockd nfs_acl sunrpc dm_crypt
lp ppdev psmouse serio_raw pcspkr i2c_piix4 parport_pc parport shpchp
intel_agp agpgart pcnet32 mii mptspi mptscsih mptbase
scsi_transport_spi floppy fbcon tileblit font bitblit softcursor
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.559829]
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560055] Pid: 23749,
comm: sync Not tainted (2.6.28-17-generic #58-Ubuntu) VMware Virtual
Platform
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560087] EIP:
0060:[<f7f6ec9e>] EFLAGS: 00210206 CPU: 1
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560729] EIP is at
nfs_page_async_flush+0x7e/0x110 [nfs]
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560769] EAX: cbef709c
EBX: c1305d80 ECX: 00000015 EDX: 00600020
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560792] ESI: db918bc0
EDI: cbef709c EBP: d6795da8 ESP: d6795d94
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560815]  DS: 007b ES:
007b FS: 00d8 GS: 0033 SS: 0068
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560869] Process sync
(pid: 23749, ti=d6794000 task=c20f8c90 task.ti=d6794000)
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560902] Stack:
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.560965]  c1305d80
d6795e68 c1305d80 d6795e68 ffffffff d6795db8 f7f6ed93 c1305d80
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.561094]  c1305d80
d6795dc8 f7f6ee94 c1305d80 00000000 d6795e54 c01962e3 00000000
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.561094]  0000000e
f7f6ee80 d6795f44 cbef70d4 f61ef024 00000000 00000001 d6795ea0
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.561094] Call Trace:
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.561094]  [<f7f6ed93>] ?
nfs_do_writepage+0x63/0x70 [nfs]
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.561094]  [<f7f6ee94>] ?
nfs_writepages_callback+0x14/0x30 [nfs]
Feb 24 07:41:54 la16-cgen-dev kernel: [1638079.561094]  [<c01962e3>] ?
write_cache_pages+0x1a3/0x380
[..]



Attached syslog file.
