Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbXIROro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbXIROro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbXIROrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:47:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53937 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152AbXIROrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:47:35 -0400
Date: Tue, 18 Sep 2007 16:47:34 +0200
From: Jan Kara <jack@suse.cz>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: iso9660 vs udf
Message-ID: <20070918144734.GB13304@atrey.karlin.mff.cuni.cz>
References: <20070915214926.GA31416@mette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915214926.GA31416@mette>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Today I got a CD. MacOS does not mount it and Linux does not
> mount it without an explicit filesystemtype option.
> That is,
> 	# mount /dev/hdc /dir -t iso9660
> works fine, but
> 	# mount /dev/hdc /dir
> 	mount: you didn't specify a filesystem type for /dev/hdc
>                I will try type udf
>         mount: wrong fs type, bad option, bad superblock on /dev/hdc,
>                missing codepage or other error
>                In some cases useful info is found in syslog - try
>                dmesg | tail  or so
> 	# dmesg | tail
>         UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'Wisk1956-82', timestamp 2006/03/07 16:26 (1078)
>         udf: udf_read_inode(ino 547) failed !bh
>         UDF-fs: Error in udf_iget, block=1, partition=1
> 
> Google gave me half a dozen other people that mentioned the same
> problem (with the same inode 547). Clearly some CD mastering software
> produces a format that Linux and MacOS do not handle easily.
> 
> One result of this letter will be that people with the same problem
> learn via Google that using the "-t iso9660" option may help.
> 
> What goes wrong on the mount side is that when it hesitates between
> iso9660 and udf it decides for udf when seeing "NSR02".
> Maybe the heuristics in mount should be tuned.
  Yes, this seems like a mount problem but you should contact mount
maintainer for that... I guess hardly anyone will help you with this on
this list.

> On the other hand, this filesystem announces itself as UDF
> ("CD-RTOS" "CD-BRIDGE" "CDUDF File System - Adaptec Inc"),
> perhaps the kernel code should be more robust.
> 
> If anybody feels responsible for mount and/or this kernel area
> we might discuss.
  I'm kind of taking care about UDF in kernel. What do you find
inappropriate on the kernel reaction? You mean we should produce some
better error message into the log?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
