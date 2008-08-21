Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYHULhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYHULhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbYHULhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:37:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52298 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468AbYHULhA (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:37:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: jaredeh@gmail.com
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Date: Thu, 21 Aug 2008 13:35:35 +0200
User-Agent: KMail/1.9.9
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00F0.5030403@gmail.com>
In-Reply-To: <48AD00F0.5030403@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211335.36020.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+TyKmkeZKkxbv/zPuk+/4cfH2oSHauUtrmxfF
 cZ9uN/ir+WN4k6r/I9I7MWmt1FVzg+XLlfaD8ATDAQco0ssAxG
 c07ZvqcjEMWgGJubSgVIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:
> +/***************** functions in other axfs files ******************************/
> +int axfs_get_sb(struct file_system_type *, int, const char *, void *,
> +		struct vfsmount *);
> +void axfs_kill_super(struct super_block *);
> +void axfs_profiling_add(struct axfs_super *, unsigned long, unsigned int);
> +int axfs_copy_mtd(struct super_block *, void *, u64, u64);
> +int axfs_copy_block(struct super_block *, void *, u64, u64);

*Never* put extern declarations into a .c file, that's what headers are for.
If you ever change the definition, the compiler doesn't get a chance to
warn you otherwise.

> +/******************************************************************************/
> +static int axfs_readdir(struct file *, void *, filldir_t);
> +static int axfs_mmap(struct file *, struct vm_area_struct *);
> +static ssize_t axfs_file_read(struct file *, char __user *, size_t, loff_t *);
> +static int axfs_readpage(struct file *, struct page *);
> +static int axfs_fault(struct vm_area_struct *, struct vm_fault *);
> +static struct dentry *axfs_lookup(struct inode *, struct dentry *,
> +				  struct nameidata *);
> +static int axfs_get_xip_mem(struct address_space *, pgoff_t, int, void **,
> +			    unsigned long *);

For style reasons, also please don't put static forward declarations anywhere,
but define the functions in the right order so you don't need them.

	Arnd <><
