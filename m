Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbXFYO4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbXFYO4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbXFYO4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:56:04 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:33497 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755140AbXFYO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:56:02 -0400
Date: Mon, 25 Jun 2007 16:53:55 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: arjan@infradead.org
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
Message-ID: <467fd703.72QYmCwQ6G3TPmF6%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <1182469678.2704.16.camel@laptopd505.fenrus.org>
In-Reply-To: <1182469678.2704.16.camel@laptopd505.fenrus.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> wrote:

>
> > Cdrtools ftp://ftp.berlios.de/pub/cdrecord/alpha/ offer support for an OS 
> > dependent SCSI transport. Cdrtools cannot be compiled wihout support for SCSI 
> > transport, so it is impossible to use Sun Studio to compile cdrtools.
> > 
> > Why does this happen?
> > 
> > Well, the reason is that in order to support Linux specific features, you need 
> > to include Linux specific include files (the Linux kernel include files).
>
>
> I assume you typoed and meant "cleaned up kernel include files as
> installed by make headers_install" instead.

I am thinking about kernel include files that do correct preincludes for
type-cleanness and that work if you use them without #defining __KERNEL_

> >  As 
> > these include files are currently not written in vanilla (ANSI) C but in a 
> > GCC-C-variant, other compilers do not like these include files.
>
> can you give a specific example of a header installed by make
> headers_install that breaks this way and is hurting you? Because it may
> well be possible to fix the problems, now that we have this special
> cleanup phase since several releases....

star needs "ext2_fs.h". This file is not usable at all on many Linux 
distributions, even with GCC.

libscg (cdrtools) needs "scsi/sg.h" but it currently includes a lot of other
files:

scsi-linux-sg.c:#include <linux/version.h>
scsi-linux-sg.c:#include <asm/types.h>
scsi-linux-sg.c:#include <scsi/scsi.h>
scsi-linux-sg.c:#include <linux/scsi.h>
scsi-linux-sg.c:#include <linux/fs.h>           /* From ancient versions, really needed? */
scsi-linux-sg.c:#include "block/blk.h"          /* From ancient versions, really needed? */
scsi-linux-sg.c:#include "scsi/scsi.h"
scsi-linux-sg.c:#include "scsi/sg.h"
scsi-linux-sg.c:#include <linux/cdrom.h>

If there wase _one_ clean SCSI pass through interface on Linux,
things would be a lot easier.....


Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
