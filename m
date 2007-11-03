Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbXKCAoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbXKCAoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbXKCAnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:43:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:3764 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbXKCAnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=ZHbz89sEX7D/qKlGW9QCqJe/xHJQtGYirit16/fC8j9qiHBZWyvmluWzhFDah41EbPTpqBY6MZhrO+8ZNhVxmiLzuIRoJkFmNazFy40LU2JnX3LRxuOxmjUxwXWMv/JfU+8xGCR+2ns5NzAXJbP15kW8PRIzKBGKhdW7hS56Scc=
Date: Sat, 3 Nov 2007 01:43:32 -0700
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] :
 kernel/built-in.o(.text+0x18db4):kernel/workqueue.c:823: undefined
 reference to `.L343'
Message-Id: <20071103014332.6b0ece08.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071103000413.GA22006@flint.arm.linux.org.uk>
References: <20071102202931.deb09211.Kristoffer.ericson@gmail.com>
	<20071102194818.GA22719@flint.arm.linux.org.uk>
	<20071102201023.GA16670@uranus.ravnborg.org>
	<20071103000406.30654cff.Kristoffer.ericson@gmail.com>
	<20071103000413.GA22006@flint.arm.linux.org.uk>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007 00:04:14 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sat, Nov 03, 2007 at 12:04:06AM -0700, Kristoffer Ericson wrote:
> > On Fri, 2 Nov 2007 21:10:23 +0100
> > Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > On Fri, Nov 02, 2007 at 07:48:18PM +0000, Russell King - ARM Linux wrote:
> > > > On Fri, Nov 02, 2007 at 08:29:31PM -0700, Kristoffer Ericson wrote:
> > > > > Greetings,
> > > > > 
> > > > > Haven't found anyone reporting this. Taken from the very latest linux-2.6.git pull.
> > > > > 
> > > > > dnsdomainname: Unknown host
> > > > >   UPD     include/linux/compile.h
> > > > >   CC      init/version.o
> > > > >   LD      init/built-in.o
> > > > >   LD      .tmp_vmlinux1
> > > > > kernel/built-in.o(.text+0x18db0): In function `destroy_workqueue':
> > > > > kernel/workqueue.c:823: undefined reference to `.L342'
> > > > > kernel/built-in.o(.text+0x18db4):kernel/workqueue.c:823: undefined reference to `.L343'
> > > > > make: *** [.tmp_vmlinux1] Error 1
> > > > 
> > > > I think you'll have to look at the assembly produced for workqueue.c and
> > > > work out why GCC is referencing an undefined label.  You can get the
> > > > assembly for that by doing:
> > > > 
> > > > make ARCH=arm ...etc... kernel/workqueue.s
> > > Or make that:
> > > 
> > > make ARCH=arm ...etc... kernel/workqueue.lst
> > > 
> > > to get intermixed C and assenbly
> > > 
> > > 	Sam
> > arm-unknown-linux-gnu- kernel/workqueue.1strrent:)$ make ARCH=arm CROSS_COMPILE=a
> > make: *** No rule to make target `kernel/workqueue.1st'.  Stop.
> 
> Suggest you use a better console font that allows you to identify
> the difference between '1' (one) and 'l' (lima).
Point taken.

> 
> > arm-unknown-linux-gnu- kernel/workqueue.lstrrent:)$ make ARCH=arm CROSS_COMPILE=a
> >   CHK     include/linux/version.h
> > make[1]: `include/asm-arm/mach-types.h' is up to date.
> >   CHK     include/linux/utsrelease.h
> >   CALL    scripts/checksyscalls.sh
> > <stdin>:1097:2: warning: #warning syscall fadvise64 not implemented
> > <stdin>:1265:2: warning: #warning syscall migrate_pages not implemented
> > <stdin>:1321:2: warning: #warning syscall pselect6 not implemented
> > <stdin>:1325:2: warning: #warning syscall ppoll not implemented
> > <stdin>:1365:2: warning: #warning syscall epoll_pwait not implemented
> >   MKLST   kernel/workqueue.lst
> > No System.map
> 
> You're not looking for a system.map file, but the workqueue.s or
> workqueue.lst file to find out where this nonexistent label is
> referenced.

Sorry, I misunderstod Sam's reply earlier. Tried to compile the .lst file :D
I've done some checks in the .config and seems like some setting in 'kernel hacking', caused this. Unfortunantly I changed too much at once to be sure what exactly in there caused it. 

Anyhow, thanks for helping out :)
