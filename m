Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXISAPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXISAPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 20:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXISAPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 20:15:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45937 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXISAPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 20:15:42 -0400
Date: Wed, 19 Sep 2007 05:48:28 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jan Kara <jack@suse.cz>
cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iso9660 vs udf
In-Reply-To: <20070918144734.GB13304@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.0.999.0709190534490.26241@enigma.security.iitk.ac.in>
References: <20070915214926.GA31416@mette>
 <20070918144734.GB13304@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 18 Sep 2007, Jan Kara wrote:
> 
> > Today I got a CD. MacOS does not mount it and Linux does not
> > mount it without an explicit filesystemtype option.
> > That is,
> > 	# mount /dev/hdc /dir -t iso9660
> > works fine, but
> > 	# mount /dev/hdc /dir
> > 	mount: you didn't specify a filesystem type for /dev/hdc
> >                I will try type udf
> >         mount: wrong fs type, bad option, bad superblock on /dev/hdc,
> >                missing codepage or other error
> >                In some cases useful info is found in syslog - try
> >                dmesg | tail  or so
> > 	# dmesg | tail
> >         UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'Wisk1956-82', timestamp 2006/03/07 16:26 (1078)
> >         udf: udf_read_inode(ino 547) failed !bh
> >         UDF-fs: Error in udf_iget, block=1, partition=1

That comes from udf_fill_super() but which shouldn't have been called
in the first place ...

> > Google gave me half a dozen other people that mentioned the same
> > problem (with the same inode 547). Clearly some CD mastering software
> > produces a format that Linux and MacOS do not handle easily.
> > 
> > One result of this letter will be that people with the same problem
> > learn via Google that using the "-t iso9660" option may help.
> > 
> > What goes wrong on the mount side is that when it hesitates between
> > iso9660 and udf it decides for udf when seeing "NSR02".
> > Maybe the heuristics in mount should be tuned.
>   Yes, this seems like a mount problem but you should contact mount
> maintainer for that... I guess hardly anyone will help you with this on
> this list.
> 
> > On the other hand, this filesystem announces itself as UDF
> > ("CD-RTOS" "CD-BRIDGE" "CDUDF File System - Adaptec Inc"),
> > perhaps the kernel code should be more robust.

Could you send the complete dmesg log, and what you mean with filesystem/
kernel (incorrectly?) announcing it as UDF here ... I agree with Jan,
this sounds like an issue with mount(8) to me.

> > If anybody feels responsible for mount and/or this kernel area
> > we might discuss.
>   I'm kind of taking care about UDF in kernel. What do you find
> inappropriate on the kernel reaction? You mean we should produce some
> better error message into the log?
