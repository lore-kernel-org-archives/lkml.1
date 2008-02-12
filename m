Return-Path: <linux-kernel-owner+w=401wt.eu-S1764412AbYBLUqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764412AbYBLUqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYBLUpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:45:52 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15606 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYBLUpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:45:51 -0500
Date: Tue, 12 Feb 2008 12:45:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Fabio Coatti <cova@ferrara.linux.it>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, rjw@sisk.pl
Subject: Re: stuck with 2.6.23.14 on x86_64
Message-Id: <20080212124522.1033c514.randy.dunlap@oracle.com>
In-Reply-To: <200802121847.19991.cova@ferrara.linux.it>
References: <200802121503.41328.cova@ferrara.linux.it>
	<20080212091855.d43d7926.randy.dunlap@oracle.com>
	<200802121847.19991.cova@ferrara.linux.it>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 18:47:19 +0100 Fabio Coatti wrote:

> Alle martedì 12 febbraio 2008, Randy Dunlap ha scritto:
> > On Tue, 12 Feb 2008 15:03:41 +0100 Fabio Coatti wrote:
> > > Hi all,
> > > I'm stuck in a weird situation: I'm unable to go beyond 2.6.23.14, so to
> > > fix the splice bug I've had to apply by hand the patch. (x86_64)
> > >
> > > Basically, with 2.6.24.2 (the same with 2.6.24 and .1), tha machine won't
> > > boot due to a problem with cciss driver, that prevents to find the /
> > > partition. (bug described here: Kernel Bug Tracker Bug 9859
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9859 );
> > >
> > > With kernels 2.6.23, the lastest that I can compile is 2.6.23.14;
> > > starting from .15 (and .16) I get this message:
> > >
> > > ======================
> > >   UPD     include/linux/compile.h
> > >   CC      init/version.o
> > >   LD      init/built-in.o
> > >   LD      .tmp_vmlinux1
> > > drivers/built-in.o: In function `acpi_init':
> > > bus.c:(.init.text+0x1713): undefined reference to `pm_flags'
> > > bus.c:(.init.text+0x1756): undefined reference to `pm_flags'
> > > ======================
> > >
> > > All .config are the same, (make oldconfig) beside the obvious differences
> > > between .23 and .24
> > >
> > > Hardware: x86_64 AMD 2216HE
> > > SCSI controller: HP Smart Array E200i Controller
> > > Compiler: gcc (GCC) 4.1.1
> > > binutils: 2.16.1
> > >
> > > On a x86 machine, Intel(R) Xeon(TM) CPU 3.20GHz
> > > with a cciss0: HP Smart Array 6i Controller,
> > > the 2.6.24.2 compiles just fine and works, so the cciss problems seems
> > > related only to E200i controller.
> > >
> > > Right now, on AMD64 machines, I'm forced to patch by hand the kernel,
> > > that's quite uncomfortable :)
> > >
> > > Can someone point me in the right direction to get out of this situation?
> > > Of course I can provide any further information. (.config not inlcuded
> > > now to avoid cluttering  )
> > >
> > > Thanks for any answer.
> >
> > a/ send .config file for the build problem above
> > b/ How do you download and/or apply 2.6.23.{15,16} ?
> > 	Full tarball or base tarball + patches?
> > 	If patches, what base tree are they applied to?
> >
> 
> full tarball from kernel.org (.16), tried also applying patches to 2.6.23 
> vanilla.(.15,.16) Same process leads to successful compilation for .14

OK, quite easy to reproduce when CONFIG_PM=n.
For a temp quick fix, you could enable CONFIG_PM.

Len, Rafael:  were there any recent patches for the split of ACPI & PM
that need to be backported to -stable?

Thanks.
---
~Randy
