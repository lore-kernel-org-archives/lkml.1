Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYEOM6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYEOM6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 08:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYEOM6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 08:58:40 -0400
Received: from smtp201.iad.emailsrvr.com ([207.97.245.201]:55928 "EHLO
	smtp201.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYEOM6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 08:58:39 -0400
Date: Thu, 15 May 2008 08:55:39 -0400 (EDT)
Subject: MIPS kernel hangs: Warning: unable to open an initial console.  /sbin/init
From: abhiruchi.g@vaultinfo.com
To: linux-kernel@vger.kernel.org,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       "kernel-testers" <kernel-testers@vger.kernel.org>
Reply-To: abhiruchi.g@vaultinfo.com
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: 1
Message-ID: <55815.192.168.1.71.1210856139.webmail@192.168.1.71>
X-Mailer: webmail6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My kernel hangs by initializing the system. My target is Alchemy DB1200. I use crosstool-ng to build MIPS cross toolchain and ptxdist to build ext2 filesystem.
kernel version:linux-2.6.22


I added some printk's  linux/init/main.c to see what happens.

#############################################################

	.
	.
	.
	(void) dup(0);
	(void) dup(0);

	/*
	 * We try each of these until one succeeds.
	 *
	 * The Bourne shell can be used instead of init if we are
	 * trying to recover a really broken machine.
	 */
	if (execute_command)
		run_init_process(execute_command);
	printk("before /sbin/init\n");
	run_init_process("/sbin/init");
	printk("before /etc/init\n");
	run_init_process("/etc/init");
	printk("before  /bin/init\n");
	run_init_process("/bin/init");
	printk("before  /bin/sh\n");
	run_init_process("/bin/sh");

it hangs after /sbin/init

What could be the problem?

I tried to give init="/sbin/abhi"
"abhi" is an executable file with printf statement.
but kernel stops after :


Waiting 10sec before mounting root device...
scsi 0:0:0:0: Direct-Access     Ut163    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
sd 0:0:0:0: [sda] 983808 512-byte hardware sectors (504 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 983808 512-byte hardware sectors (504 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda:<7>usb-storage: queuecommand called
 sda1
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
VFS: Mounted root (ext2 filesystem) readonly.
mount_block_root: name=/dev/root fs=ext2 flags=32769
Freeing unused kernel memory: 156k freed
Warning: unable to open an initial console.
---ag: /sbin/abhi


