Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYAGNk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYAGNk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYAGNkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:40:19 -0500
Received: from rosi.naasa.net ([212.8.0.13]:56197 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYAGNkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:40:18 -0500
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Mon, 7 Jan 2008 14:40:13 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
References: <200801071151.11200.lists@naasa.net> <200801071424.12448.lists@naasa.net> <1199712757.7143.37.camel@twins>
In-Reply-To: <1199712757.7143.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801071440.14798.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 7. Januar 2008 schrieb Peter Zijlstra:
> On Mon, 2008-01-07 at 14:24 +0100, Joerg Platte wrote:
>
> This is from: 2.6.24-rc7
>
> > kernel: pdflush       D f41c2f14     0 18822      2
> > kernel:        f673f000 00000046 00000286 f41c2f14 f5194ce0 00000286
> > 00000286 f41c2f14 kernel:        00175279 f41c2f6c 00000000 c0271f6c
> > f5ff363c f5ff3644 c0354a90 c0354a90 kernel:        00175279 c0123251
> > f5194b80 c03546c0 c0271f67 6c666470 00687375 00000000 kernel: Call Trace:
> > kernel:  [<c0271f6c>] schedule_timeout+0x6e/0x8b
> > kernel:  [<c0123251>] process_timeout+0x0/0x5
> > kernel:  [<c0271f67>] schedule_timeout+0x69/0x8b
> > kernel:  [<c027179a>] __sched_text_start+0x3a/0x70
> > kernel:  [<c014d34b>] congestion_wait+0x4e/0x62
> > kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
> > kernel:  [<c014971e>] pdflush+0x0/0x1bf
> > kernel:  [<c01493c6>] wb_kupdate+0x8c/0xd1
> > kernel:  [<c014971e>] pdflush+0x0/0x1bf
> > kernel:  [<c0149839>] pdflush+0x11b/0x1bf
> > kernel:  [<c014933a>] wb_kupdate+0x0/0xd1
> > kernel:  [<c012bd71>] kthread+0x36/0x5d
> > kernel:  [<c012bd3b>] kthread+0x0/0x5d
> > kernel:  [<c010493b>] kernel_thread_helper+0x7/0x10
> > kernel:  =======================
>
> What filesystem are you using?

Here you can see all currently mounted filesystems:

/dev/sda6 on / type ext3 (rw,noatime,errors=remount-ro,acl)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
procbususb on /proc/bus/usb type usbfs (rw)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
/dev/sda7 on /tmp type ext2 (rw,noatime,errors=remount-ro,acl)
/dev/sda8 on /export type ext3 (rw,noatime,errors=remount-ro,acl)
/dev/sda1 on /winxp type ntfs (rw,umask=002,gid=10000,nls=utf8)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
automount(pid4936) on /amnt type autofs 
(rw,fd=4,pgrp=4936,minproto=2,maxproto=4)
automount(pid4965) on /home type autofs 
(rw,fd=4,pgrp=4965,minproto=2,maxproto=4)
nfsd on /proc/fs/nfsd type nfsd (rw)
/export/home/jplatte on /home/jplatte type none (rw,bind)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc 
(rw,noexec,nosuid,nodev)

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

