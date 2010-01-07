Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670Ab0AGUm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0AGUm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651Ab0AGUmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:42:55 -0500
Received: from er-systems.de ([85.25.136.202]:52014 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab0AGUmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:42:54 -0500
Date: Thu, 7 Jan 2010 21:42:52 +0100 (CET)
From: Thomas Voegtle <tv@lio96.de>
To: Greg KH <gregkh@suse.de>
cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, dmonakhov@openvz.org
Subject: Re: Linux 2.6.31.10
In-Reply-To: <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
Message-ID: <alpine.LNX.2.00.1001072141340.26784@er-systems.de>
References: <20100106234533.GC1960@kroah.com> <alpine.LNX.2.00.1001071522480.5426@er-systems.de> <20100107180449.GA17495@suse.de> <alpine.LNX.2.00.1001072033301.26784@er-systems.de> <20100107194131.GA22983@suse.de>
 <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.95.3/10267/Thu Jan  7 03:04:56 2010 signatures .
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Thomas Voegtle wrote:

> Done, between 2.6.31.9 and 2.6.31.11
>
>
> c169e13a6662cbf36fc0098508e7aa31b49cbf23 is first bad commit
> commit c169e13a6662cbf36fc0098508e7aa31b49cbf23
> Author: Dmitry Monakhov <dmonakhov@openvz.org>
> Date:   Mon Dec 14 15:21:13 2009 +0300
>
>    quota: decouple fs reserved space from quota reservation
>
>    commit fd8fbfc1709822bd94247c5b2ab15a5f5041e103 upstream.
>
>
>
> Reverting that patch on top of 2.6.31.11 fixes the problem for me.


Funny thing, I have the problem with 2.6.33-rc3, too:


------------[ cut here ]------------
kernel BUG at fs/quota/dquot.c:1350!
invalid opcode: 0000 [#1]
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias

Pid: 3061, comm: rpm Not tainted 2.6.33-rc3-BIG #73 P3TSSA/P3TSSA
EIP: 0060:[<c10c05d8>] EFLAGS: 00010246 CPU: 0
EIP is at inode_reserved_space+0x13/0x1b
EAX: cf25b5c4 EBX: cf25b5c4 ECX: 00000000 EDX: 00000000
ESI: cf25b5c4 EDI: 00000000 EBP: d3536ebc ESP: d3536ebc
  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process rpm (pid: 3061, ti=d3536000 task=d5c50000 task.ti=d3536000)
Stack:
  d3536f1c c10c246a d79a4b00 d3536edc c10a4884 d3536ef4 c10c1fea 00000000
<0> 00000000 00000000 00000064 cf25b5c4 cf25b5c4 d701c800 d3536f1c 
00000000
<0> d766b000 00000000 00000000 d766b0a0 0000b140 cf25b5c4 d3536f58 
ffffff86
Call Trace:
  [<c10c246a>] ? dquot_transfer+0xf2/0x48b
  [<c10a4884>] ? mntput_no_expire+0x19/0x6c
  [<c10c1fea>] ? dqget+0x210/0x260
  [<c10c05aa>] ? vfs_dq_transfer+0x5f/0x7a
  [<c10a2edd>] ? notify_change+0x177/0x25e
  [<c10930c8>] ? chown_common+0x5e/0x70
  [<c10931fe>] ? sys_lchown+0x3d/0x58
  [<c10212a7>] ? sysenter_do_call+0x12/0x2c
Code: c0 0f b6 c0 eb 02 31 c0 5b 5e 5d c3 a8 08 75 b0 eb f4 a8 08 75 c9 eb 
d5 55 8b 90 90 00 00 00 89 e5 8b 52 24 8b 52 44 85 d2 75 04 <0f> 0b eb fe 
ff d2 5d c3 55 89 e5 57 89 c7 56 53 83 ec 1c 8b 35
EIP: [<c10c05d8>] inode_reserved_space+0x13/0x1b SS:ESP 0068:d3536ebc
---[ end trace 0cbcf5a4693c0845 ]---

