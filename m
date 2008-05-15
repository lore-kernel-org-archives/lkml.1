Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYEONOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYEONOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYEONO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:14:26 -0400
Received: from smtp201.iad.emailsrvr.com ([207.97.245.201]:33321 "EHLO
	smtp201.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYEONOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:14:25 -0400
Date: Thu, 15 May 2008 09:14:24 -0400 (EDT)
Subject: MIPS toolchain : should I choose shared library option for Alchemy DB1200
From: abhiruchi.g@vaultinfo.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers" <kernel-testers@vger.kernel.org>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Reply-To: abhiruchi.g@vaultinfo.com
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: 1
Message-ID: <56119.192.168.1.70.1210857264.webmail@192.168.1.70>
X-Mailer: webmail6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
   To build cross toolchain for MIPS, should I choose shared library option. My kernel hangs after :

Warning: unable to open an initial console.
/sbin/init


The function is in init/main.c.


static int noinline init_post(void)
{
        ..
        ..
        ..

        if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
                printk(KERN_WARNING "Warning: unable to open an initial console.
\n");

        (void) sys_dup(0);
        (void) sys_dup(0);

        if (ramdisk_execute_command) {
                run_init_process(ramdisk_execute_command);
                printk(KERN_WARNING "Failed to execute %s\n",
                                ramdisk_execute_command);
        }

        ..
        ..
        printk(KERN_WARNING "-- ag. sbin init\n");
        run_init_process("/sbin/init");
        printk(KERN_WARNING "-- ag. etc init\n");
        run_init_process("/etc/init");
        printk(KERN_WARNING "-- ag. bin init\n");
        run_init_process("/bin/init");
        printk(KERN_WARNING "-- ag. bin sh\n");
        run_init_process("/bin/sh");

        panic("No init found.  Try passing init= option to kernel.");

 }           
                                         

