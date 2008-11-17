Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYKQVXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYKQVXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKQVXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:23:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42465 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751468AbYKQVXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:23:23 -0500
Date: Mon, 17 Nov 2008 16:23:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manish Lachwani <mlachwani@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: oops in file_storage.c
In-Reply-To: <431757fd0810231055m4b697888j9132f7183a2318c@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0811171622520.18528-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Manish Lachwani wrote:

> Hi Alan,
> 
> Yes, I am trying out the changes below. Will let you know how it goes.
> If it works well, I will send an updated patch.

> 
> diff --git a/drivers/usb/gadget/file_storage.c
> b/drivers/usb/gadget/file_storage.c index 3e807f0..844f992 100644 ---
> a/drivers/usb/gadget/file_storage.c +++
> b/drivers/usb/gadget/file_storage.c @@ -1927,26 +1927,11 @@ static
> int do_write(struct fsg_dev *fsg)
>  static int fsync_sub(struct lun *curlun)
>  {
>         struct file     *filp = curlun->filp;
> -       struct inode    *inode;
> -       int             rc, err;
> 
>         if (curlun->ro || !filp)
>                 return 0;
> -       if (!filp->f_op || !filp->f_op->fsync)
> -               return -EINVAL;
> 
> -       inode = filp->f_path.dentry->d_inode;
> -       mutex_lock(&inode->i_mutex);
> -       rc = filemap_fdatawrite(inode->i_mapping);
> -       err = filp->f_op->fsync(filp, filp->f_path.dentry, 1);
> -       if (!rc)
> -               rc = err;
> -       err = filemap_fdatawait(inode->i_mapping);
> -       if (!rc)
> -               rc = err;
> -       mutex_unlock(&inode->i_mutex);
> -       VLDBG(curlun, "fdatasync -> %d\n", rc);
> -       return rc;
> +       return do_fsync(filp, 0);
>  }
> 
>  static void fsync_all(struct fsg_dev *fsg)
> diff --git a/fs/sync.c b/fs/sync.c
> index e700eb1..53ff1f3 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -111,6 +111,7 @@ long do_fsync(struct file *file, int datasync)
>  out:
>         return ret;
>  }
> +EXPORT_SYMBOL(do_fsync);
> 
>  static long __do_fsync(unsigned int fd, int datasync)
>  {

Any news on this?

Alan Stern

