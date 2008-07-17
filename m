Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbYGQOpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbYGQOpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbYGQOpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:45:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:64337 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbYGQOpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=evu728jtHM4qxnbIbTa6pemVoXhF5tx8gVK/ekcYMf2Vafwzg5OTnx1YEsTUY5MMhf
         MmfAmKBXU0l1X3yiIRfuDgWsC+gX7F5p8p/Wz8RfmmiJOVns2cIfFQnCU4UgbaNMAbXS
         CxudOt08qBB2tcUP3Y/QtWR+wqW2kBUeAYMFc=
Subject: Re: Usage of kgdb in v2.6.26
From: ZC Miao <hellwolf.misty@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <487F45B8.4010708@windriver.com>
References: <1216245603.3664.29.camel@hellwolf-sony.freehell.org>
	 <487F45B8.4010708@windriver.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 15:45:21 +0100
Message-Id: <1216305921.3905.8.camel@hellwolf-sony.freehell.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow, that's a magic! It works now!

I think we should document it in the Documentation of kgdb.

Thanks!

On Thu, 2008-07-17 at 08:14 -0500, Jason Wessel wrote:
> 
> Do you have CONFIG_DEBUG_RODATA=y in your kernel config?
> 
> There is a presently a known problem where breakpoints will silently
> fail to plant when this is turned on.
> 
> Jason.
> 
> ZC Miao wrote:
> > I tried to use the kgdb from v2.6.26, but met few problems.
> > I use :
> > 1. gdb 6.8 (gdb-6.8-11.fc9.i386)
> > 2. kernel v2.6.26 source code
> > 3. Qemu 0.9.1 (qemu-0.9.1-5.fc9.i386)
> > 4. Host is : 2.6.25.10-86.fc9.i686
> > 5. Cpu : Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz
> >
> >
> > * Firstly I compile kernel 2.6.26 with kgdb support :
> > CONFIG_KGDB=y
> > CONFIG_KGDB_SERIAL_CONSOLE=y
> >
> > * Then I use qemu to boot my kernel along with a rootfs that I created,
> > with a qemu option that makes a local tcp port a listening service as a
> > serial port for the emulated system. The kernel arguments I gave is :
> > nfsroot=192.168.200.1:/path/to/rootfs,udp,nolock ip=dhcp root=/dev/nfs
> > ro single kgdboc=ttyS0,115200 kgdbwait
> >
> > * After the kernel loaded and boot for a while, the gdb receives a
> > signal and hangs the kernel :
> > kgdb_register_io_module (new_kgdb_io_ops=<value optimized out>)
> >     at /data/home/hellwolf/mydoc/prog/linux/linux-2.6/kernel/kgdb.c:1674
> > (gdb) 
> >
> > Question 1 :
> > * If I type "b sys_read", and then "c", the kernel continues until I
> > get :
> >
> > ---------------------------------------------------------------
> > [New Thread 1]
> > Cannot remove breakpoints because program is no longer writable.
> > It might be running in another process.
> > Further execution is probably impossible.
> >
> > Breakpoint 1, sys_read (fd=3, buf=0xbfdb31dc "", count=512)
> >
> > at /data/home/hellwolf/mydoc/prog/linux/linux-2.6/fs/read_write.c:360
> > (gdb) 
> > ---------------------------------------------------------------
> >
> > Why "program is no longer writable" happens here?
> >
> > Question 2 :
> > * If I directly type "c" when kgdbwait triggered. And use Sys-Rq+G to
> > interrupt the kernel, I will get :
> > ---------------------------------------------------------------
> > [New Thread -1]
> >
> > Program received signal SIGTRAP, Trace/breakpoint trap.
> > [Switching to Thread -1]
> > sysrq_handle_gdb (key=103, tty=0xc78f6400)
> >     at /data/home/hellwolf/mydoc/prog/linux/linux-2.6/kernel/kgdb.c:167
> > (gdb)  
> > ---------------------------------------------------------------
> > Here if I type "c sys_read" and "c", it never actually makes any break
> > points, I will never receive a break from gdb.
> >
> >
> > I don't know if I made anything wrong, or I missed any important thing,
> > so I post here and would like to get some help from you.
> >
> > Thanks. 
> >
> > --
> > ZC Miao (hellwolf.misty@gmail.com)
> > Blog http://hellwolf.cublog.cn
> >
> > gpg --keyserver pgp.mit.edu --recv-key 0x6B174C6F
> >
> > Most people deserve each other.
> > 		-- Shirley
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >   
> 
--
ZC Miao (hellwolf.misty@gmail.com)
Blog http://hellwolf.cublog.cn

gpg --keyserver pgp.mit.edu --recv-key 0x6B174C6F

The human mind ordinarily operates at only ten percent of its capacity
-- the rest is overhead for the operating system.

