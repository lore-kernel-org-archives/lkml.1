Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYEONcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYEONcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYEONci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:32:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:34906 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbYEONch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sJgaL3JSwhXQjNwPpddQKuE4+ViCgIKrpfL8Y7ME8MnbEJ+9+ReqCi7Xr3CjfO13B8vOKF/SG/yL1EbEcRTFFL9O28k2FXYDZYUzXvxEVAaGirk8J1ey+VB62eC6TN/8rr6/qTJ/GSsaHjnxbBu1sn3KPJt/70kd/W1EhV5Ql3M=
Message-ID: <5a8aa6680805150632m48e4fc5ck527b25c03e441986@mail.gmail.com>
Date: Thu, 15 May 2008 15:32:26 +0200
From: "Michael Wood" <esiotrot@gmail.com>
To: abhiruchi.g@vaultinfo.com
Subject: Re: MIPS toolchain : should I choose shared library option for Alchemy DB1200
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kernel-testers <kernel-testers@vger.kernel.org>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
In-Reply-To: <56119.192.168.1.70.1210857264.webmail@192.168.1.70>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <56119.192.168.1.70.1210857264.webmail@192.168.1.70>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, May 15, 2008 at 3:14 PM,  <abhiruchi.g@vaultinfo.com> wrote:
> hi,
>   To build cross toolchain for MIPS, should I choose shared library option. My kernel hangs after :
>
> Warning: unable to open an initial console.
> /sbin/init

The "unable to open an initial console" message is a red herring.  I
have seen it many times, e.g. running OpenWrt.  It doesn't seem to be
a problem.

> The function is in init/main.c.
>
> static int noinline init_post(void)
> {
>        ..
>        ..
>        ..
>
>        if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
>                printk(KERN_WARNING "Warning: unable to open an initial console.
> \n");
>
>        (void) sys_dup(0);
>        (void) sys_dup(0);
>
>        if (ramdisk_execute_command) {
>                run_init_process(ramdisk_execute_command);
>                printk(KERN_WARNING "Failed to execute %s\n",
>                                ramdisk_execute_command);
>        }
>
>        ..
>        ..
>        printk(KERN_WARNING "-- ag. sbin init\n");
>        run_init_process("/sbin/init");
>        printk(KERN_WARNING "-- ag. etc init\n");
>        run_init_process("/etc/init");
>        printk(KERN_WARNING "-- ag. bin init\n");
>        run_init_process("/bin/init");
>        printk(KERN_WARNING "-- ag. bin sh\n");
>        run_init_process("/bin/sh");
>
>        panic("No init found.  Try passing init= option to kernel.");
>
>  }

-- 
Michael Wood <esiotrot@gmail.com>
