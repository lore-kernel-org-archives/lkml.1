Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbYF0RGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbYF0RGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYF0RGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:06:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37894 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbYF0RGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:06:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Date: Fri, 27 Jun 2008 19:07:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <1214584985.22228.15.camel@localhost>
In-Reply-To: <1214584985.22228.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271907.29968.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 of June 2008, Soeren Sonnenburg wrote:
> Dear all,
> 
> Anyone else seeing this? Happened after resuming from s2both (from
> disk)...

At what point exactly did it happen?

> VFS: Mounted root (ext2 filesystem).
> ------------[ cut here ]------------
> kernel BUG at kernel/power/snapshot.c:493!
> invalid opcode: 0000 [#1] PREEMPT SMP 
> Modules linked in:
> 
> Pid: 568, comm: linuxrc Not tainted (2.6.26-rc7-sonne #35)
> EIP: 0060:[<c0157f99>] EFLAGS: 00010282 CPU: 0
> EIP is at memory_bm_set_bit+0x29/0x30
> EAX: fffffff2 EBX: f7165f1c ECX: 00000000 EDX: 03000200
> ESI: f7115000 EDI: b7f2a008 EBP: f7165f28 ESP: f7165f18
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process linuxrc (pid: 568, ti=f7164000 task=f7b65f80 task.ti=f7164000)
> Stack: f7165f1c 00000013 f7117000 00000002 f7165f5c c0158e9b bf96e5ec c02dd570 
>        00001000 c05fa980 00000008 00000008 00000000 00000000 f7000200 c05fa980 
>        b7f2a008 f7165f70 c015b3af f7000200 b7f2a008 00001000 f7165f90 c0185e28 
> Call Trace:
>  [<c0158e9b>] ? snapshot_write_next+0xcb/0x7a0
>  [<c02dd570>] ? write_chan+0x0/0x380
>  [<c015b3af>] ? snapshot_write+0x1f/0x70
>  [<c0185e28>] ? vfs_write+0x98/0x120
>  [<c015b390>] ? snapshot_write+0x0/0x70
>  [<c0185f6d>] ? sys_write+0x3d/0x70
>  [<c010333a>] ? syscall_call+0x7/0xb
>  =======================
> Code: 00 00 55 89 e5 53 83 ec 0c 8d 4d f8 8d 5d f4 89 1c 24 e8 4b ff ff ff 85 c0
> EIP: [<c0157f99>] memory_bm_set_bit+0x29/0x30 SS:ESP 0068:f7165f18
> ---[ end trace 70a926e889075b3c ]---
