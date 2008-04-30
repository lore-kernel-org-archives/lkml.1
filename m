Return-Path: <linux-kernel-owner+w=401wt.eu-S1762648AbYD3PXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762648AbYD3PXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbYD3PXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:23:05 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:47518 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbYD3PXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:23:03 -0400
X-Greylist: delayed 1960 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 11:23:03 EDT
Message-ID: <18456.34604.472989.35082@ipc1.ka-ro>
Date: Wed, 30 Apr 2008 16:50:20 +0200
From: =?iso-8859-15?q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Subject: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount point inside a read only filesystem
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when trying to create a directory path with 'mkdir -p' with the root
being a mount point of a writeable filesystem that exists inside a
read-only file system, mkdir return -EROFS.

This was tested with the latest git-tree from:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

The last kernel I know of this has been working was 2.6.22.

E.g.:
|root@triton1:/# mount
|rootfs on / type rootfs (rw)
|/dev/root on / type jffs2 (ro)
|proc on /proc type proc (rw)
|sysfs on /sys type sysfs (rw)
|/dev/root on /dev/.static/dev type jffs2 (ro)
|tmpfs on /dev type tmpfs (rw,size=10240k,mode=755)
|tmpfs on /var type tmpfs (rw)
|tmpfs on /tmp type tmpfs (rw)
|devpts on /dev/pts type devpts (rw,gid=5,mode=620)
|tmpfs on /dev/shm type tmpfs (rw)
|root@triton1:/# mkdir -p /dev/.udev/db
|mkdir: Cannot create directory `/dev/': Read-only file system

While:
|root@triton1:/# cd /dev
|root@triton1:/# mkdir -p .udev/db
works as expected...

Has anyone else encountered this problem already?
I've searched the archives but could not find anything related to this
problem.



Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
