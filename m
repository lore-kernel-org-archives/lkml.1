Return-Path: <linux-kernel-owner+w=401wt.eu-S1031390AbXDJSZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031390AbXDJSZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031393AbXDJSZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:25:13 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:55545 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031390AbXDJSZL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:25:11 -0400
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: kernel space to user space /bin/sh startup
Date: Tue, 10 Apr 2007 11:22:38 -0700
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel space to user space /bin/sh startup
Thread-Index: Acd7nTfY4pXeuaTFSfaV537fMWXMBQ==
From: "Tom Strader" <tom.strader@xilinx.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Apr 2007 18:22:39.0903 (UTC) FILETIME=[38F54AF0:01C77B9D]
Message-Id: <20070410182240.3AFAF590046@mail41-cpk.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to boot linux on a PXA270 and I think I almost have it but
the shell seems to not be outputting to the terminal.  The kernel boots,
mounts the root file system, opens ttyS0 and proceeds to call
run_init_process("/bin/sh") however I see no login prompt or shell
appear.  I am using ptxdist to build the kernel and jffs2 image.  After
run_init_process("/bin/sh") is run I can type on the console and
characters are echoed back to the screen, but still no other output.  Is
it possible that the output is being directed to somewhere which is not
correct?  

My /etc/inittab is as follows: 
#############################################################
# 
# /etc/inittab
#
# $Id: inittab 1681 2004-09-01 18:12:49Z  $
#
console::sysinit:/etc/init.d/rcS
console::respawn:/sbin/getty -L 115200 /dev/ttyS0 vt100
# Stuff to do before rebooting
::ctrlaltdel:/sbin/reboot
::shutdown:/bin/umount -a -r
#############################################################

My /etc/init.d/rcS is as follows:
#############################################################
#!/bin/sh
#
# /etc/init.d/rcS
#
# $Id: rcS 2054 2004-11-25 10:57:09Z mkl $
#
echo -n "mounting filesystems..."
mount -a 2>/dev/null
echo "done."
# modprobe ppp_async
# loadkmap < /etc/boottime.kmap
# set hostname 
test -e /etc/hostname && hostname -F /etc/hostname
echo -n "creating Network-Device lo..."
ifconfig lo up 127.0.0.1
echo "done."
echo "running rc.d services..."
run-parts -a start /etc/rc.d
#############################################################

This is the final output I see.
VFS: Mounted root (jffs2 filesystem).
Freeing init memory: 76K
opening ttyS0...uart_open(0) called

Now I can type on the console and characters are echoed back, pressing
ctrl-c echoes: "uart_flush_buffer(0) called" so the code is still
running, but I am not sure where I am or why I see no login prompt or
shell command line.
I never see the "mounting filesystems..." echoed to the screen, but the
code does not stall and no errors are reported by the kernel.  Any help
during the transition from init/main.c in kernel space to user space
would be appreciated, so I could debug this further.
I have looked around and have not seen a solution for my problem, most
likely due to the fact that I am not entirely sure what the problem is.


Thanks in advance for your time,
Tom Strader


