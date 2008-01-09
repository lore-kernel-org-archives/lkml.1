Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYAIGNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYAIGNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYAIGNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:13:25 -0500
Received: from rosi.naasa.net ([212.8.0.13]:33918 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYAIGNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:13:24 -0500
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Wed, 9 Jan 2008 07:13:14 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <200801071440.14798.lists@naasa.net> <399849251.21417@ustc.edu.cn>
In-Reply-To: <399849251.21417@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801090713.15655.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 9. Januar 2008 schrieb Fengguang Wu:
> > /dev/sda6 on / type ext3 (rw,noatime,errors=remount-ro,acl)
> > tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
> > proc on /proc type proc (rw,noexec,nosuid,nodev)
> > sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
> > procbususb on /proc/bus/usb type usbfs (rw)
> > udev on /dev type tmpfs (rw,mode=0755)
> > tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
> > devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
> > fusectl on /sys/fs/fuse/connections type fusectl (rw)
> > /dev/sda7 on /tmp type ext2 (rw,noatime,errors=remount-ro,acl)
> > /dev/sda8 on /export type ext3 (rw,noatime,errors=remount-ro,acl)
> > /dev/sda1 on /winxp type ntfs (rw,umask=002,gid=10000,nls=utf8)
>
> So they are ext3/ext2/ntfs.  What if you umount ntfs? and ext2 if possible?

Unmounting ntfs doesn't help, hence I converted the remaining ext2 filesystem 
to ext3, modified the fstab entry accordingly and rebooted. Now everything 
seems to be fine! Top reports an idle system and there is no abnormal iowait 
any longer! Seems to be ext2 was causing this! Later today I can try to 
remount the filesystem as ext2 to be sure the bug shows up again.

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605
