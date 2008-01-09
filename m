Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYAID1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYAID1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYAID1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:27:24 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59270 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751601AbYAID1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:27:23 -0500
Message-ID: <399849251.21417@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 9 Jan 2008 11:27:24 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: jplatte@naasa.net
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801071424.12448.lists@naasa.net> <1199712757.7143.37.camel@twins> <200801071440.14798.lists@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801071440.14798.lists@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JCRbA-0002bh-3c@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 02:40:13PM +0100, Joerg Platte wrote:
> Am Montag, 7. Januar 2008 schrieb Peter Zijlstra:
> > On Mon, 2008-01-07 at 14:24 +0100, Joerg Platte wrote:
> >
> > This is from: 2.6.24-rc7
> >
> > > kernel: pdflush       D f41c2f14     0 18822      2
> > > kernel:        f673f000 00000046 00000286 f41c2f14 f5194ce0 00000286
> > > 00000286 f41c2f14 kernel:        00175279 f41c2f6c 00000000 c0271f6c
> > > f5ff363c f5ff3644 c0354a90 c0354a90 kernel:        00175279 c0123251
> > > f5194b80 c03546c0 c0271f67 6c666470 00687375 00000000 kernel: Call Trace:
> > > kernel:  [<c0271f6c>] schedule_timeout+0x6e/0x8b
> > > kernel:  [<c0123251>] process_timeout+0x0/0x5
> > > kernel:  [<c0271f67>] schedule_timeout+0x69/0x8b
> > > kernel:  [<c027179a>] __sched_text_start+0x3a/0x70
> > > kernel:  [<c014d34b>] congestion_wait+0x4e/0x62
> > > kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
> > > kernel:  [<c014971e>] pdflush+0x0/0x1bf
> > > kernel:  [<c01493c6>] wb_kupdate+0x8c/0xd1
> > > kernel:  [<c014971e>] pdflush+0x0/0x1bf
> > > kernel:  [<c0149839>] pdflush+0x11b/0x1bf
> > > kernel:  [<c014933a>] wb_kupdate+0x0/0xd1
> > > kernel:  [<c012bd71>] kthread+0x36/0x5d
> > > kernel:  [<c012bd3b>] kthread+0x0/0x5d
> > > kernel:  [<c010493b>] kernel_thread_helper+0x7/0x10
> > > kernel:  =======================
> >
> > What filesystem are you using?
> 
> Here you can see all currently mounted filesystems:
> 
> /dev/sda6 on / type ext3 (rw,noatime,errors=remount-ro,acl)
> tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
> proc on /proc type proc (rw,noexec,nosuid,nodev)
> sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
> procbususb on /proc/bus/usb type usbfs (rw)
> udev on /dev type tmpfs (rw,mode=0755)
> tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
> devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
> fusectl on /sys/fs/fuse/connections type fusectl (rw)
> /dev/sda7 on /tmp type ext2 (rw,noatime,errors=remount-ro,acl)
> /dev/sda8 on /export type ext3 (rw,noatime,errors=remount-ro,acl)
> /dev/sda1 on /winxp type ntfs (rw,umask=002,gid=10000,nls=utf8)

So they are ext3/ext2/ntfs.  What if you umount ntfs? and ext2 if possible?

