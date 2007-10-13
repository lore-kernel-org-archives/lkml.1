Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbXJMACt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbXJMACt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932496AbXJMAC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:02:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58640 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbXJMAC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:02:26 -0400
Date: Sat, 13 Oct 2007 01:02:21 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Philip Langdale <philipl@overt.org>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hiddev: Add 32bit ioctl compatibilty
Message-ID: <20071013000221.GC8181@ftp.linux.org.uk>
References: <47100864.2090208@overt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47100864.2090208@overt.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 04:51:00PM -0700, Philip Langdale wrote:
> The hiddev driver currently lacks 32bit ioctl compatibility, so
> if you're running with a 64bit kernel and 32bit userspace, it won't
> work.
> 
> I'm pretty sure that the only thing missing is a compat_ioctl
> implementation as all structs have fixed size fields.
> 
> +static long hiddev_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	return hiddev_ioctl(inode, file, cmd, compat_ptr(arg));
> +}

Just how many instances of that sucker do we need?  It's nothing but

     struct inode *inode = file->f_path.dentry->d_inode;
     return file->f_op->ioctl(inode, file, cmd, compat_ptr(arg));
