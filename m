Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbXKNFZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbXKNFZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXKNFZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:25:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:59115 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXKNFZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:25:08 -0500
Date: Tue, 13 Nov 2007 21:23:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, bfields@fieldses.org, hch@lst.de,
       viro@zeniv.linux.org.uk, apw@shadowen.org
Subject: Re: mm snapshot broken-out-2007-11-13-04-14 Build Fails - linking
 when !CONFIG_NFS_V4
Message-Id: <20071113212331.a2f34e10.randy.dunlap@oracle.com>
In-Reply-To: <20071113195136.GA16890@linux.vnet.ibm.com>
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
	<20071113195136.GA16890@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 01:21:36 +0530 Kamalesh Babulal wrote:

> Hi Andrew,
> 
> The kernel build fails, with the following error
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> fs/built-in.o(.text+0x5d632): In function `nfs_free_unlinkdata':
> fs/nfs/unlink.c:32: undefined reference to `nfs_sb_deactive'
> fs/built-in.o(.rodata+0x5c5c): In function `do_execve':
> fs/exec.c:1355: undefined reference to `nfs_put_super'
> make: *** [.tmp_vmlinux1] Error 1
> 
> I suspect nfs-stop-sillyname-renames-and-unmounts-from-racing.patch,
> is causing the problem. The definition of the function is between
> CONFIG_NFS_V4 in fs/nfs/super.c.
> 
> During the compilation # CONFIG_NFS_V4 is not set.

Reported and hopefully fixed.  Patch is here:
http://lkml.org/lkml/2007/11/13/211

---
~Randy
