Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbXBIXTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbXBIXTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXBIXTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:19:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53745 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXBIXTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:19:08 -0500
Date: Fri, 9 Feb 2007 15:18:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 01/22] filesystem helpers for custom 'struct file's
Message-Id: <20070209151848.3b7f98c1.akpm@linux-foundation.org>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
References: <20070209225329.27619A62@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 14:53:29 -0800
Dave Hansen <hansendc@us.ibm.com> wrote:

> +/*
> + * Note: This is a crappy interface.  It is here to make
> + * merging with the existing users of get_empty_filp()
> + * who have complex failure logic easier.  All users
> + * of this should be moving to alloc_file().
> + */
> +int init_file(struct file *file, struct vfsmount *mnt,
> +	   struct dentry *dentry, mode_t mode,
> +	   const struct file_operations *fop)

crappy name too ;)  At least two filesystems have defined their own
static-scope init_file() and so they'll explode if they somehow maange
to include file.h.

I guess we can cross that bridge when we fall off it, but sometime it might be
prudent to do s/init_file/configfs_init_file/ and ditto sysfs_init_file.
