Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbXGIPVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbXGIPVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXGIPV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:21:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55347 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750796AbXGIPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:21:28 -0400
Message-ID: <46925270.2010308@sgi.com>
Date: Mon, 09 Jul 2007 17:21:20 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060527)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-altix@sgi.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       Bruce Losure <blosure@sgi.com>
Subject: Re: [PATCH] mbcs: Remove lots of global symbols
References: <20070709145048.6de579fa@the-village.bc.nu>
In-Reply-To: <20070709145048.6de579fa@the-village.bc.nu>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> MBCS has a collection of things that searches say are not used elsewhere
> and could be static. If this is the case they should be static, if not
> then someone at SGI should rename things like "soft_list" so they don't
> pollute the global namespace with generic names...
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Hi Alan,

Bruce says the changes should be fine, so

Signed-off-by: Bruce Losure <blosure@sgi.com>

Cheers,
Jes


> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc6-mm1/drivers/char/mbcs.c linux-2.6.22-rc6-mm1/drivers/char/mbcs.c
> --- linux.vanilla-2.6.22-rc6-mm1/drivers/char/mbcs.c	2007-07-02 20:47:23.000000000 +0100
> +++ linux-2.6.22-rc6-mm1/drivers/char/mbcs.c	2007-07-09 12:11:02.250630816 +0100
> @@ -39,14 +39,14 @@
>  #else
>  #define DBG(fmt...)
>  #endif
> -int mbcs_major;
> +static int mbcs_major;
>  
> -LIST_HEAD(soft_list);
> +static LIST_HEAD(soft_list);
>  
>  /*
>   * file operations
>   */
> -const struct file_operations mbcs_ops = {
> +static const struct file_operations mbcs_ops = {
>  	.open = mbcs_open,
>  	.llseek = mbcs_sram_llseek,
>  	.read = mbcs_sram_read,
> @@ -377,7 +377,7 @@
>  	return rv;
>  }
>  
> -int mbcs_open(struct inode *ip, struct file *fp)
> +static int mbcs_open(struct inode *ip, struct file *fp)
>  {
>  	struct mbcs_soft *soft;
>  	int minor;
> @@ -394,7 +394,7 @@
>  	return -ENODEV;
>  }
>  
> -ssize_t mbcs_sram_read(struct file * fp, char __user *buf, size_t len, loff_t * off)
> +static ssize_t mbcs_sram_read(struct file * fp, char __user *buf, size_t len, loff_t * off)
>  {
>  	struct cx_dev *cx_dev = fp->private_data;
>  	struct mbcs_soft *soft = cx_dev->soft;
> @@ -418,7 +418,7 @@
>  	return rv;
>  }
>  
> -ssize_t
> +static ssize_t
>  mbcs_sram_write(struct file * fp, const char __user *buf, size_t len, loff_t * off)
>  {
>  	struct cx_dev *cx_dev = fp->private_data;
> @@ -443,7 +443,7 @@
>  	return rv;
>  }
>  
> -loff_t mbcs_sram_llseek(struct file * filp, loff_t off, int whence)
> +static loff_t mbcs_sram_llseek(struct file * filp, loff_t off, int whence)
>  {
>  	loff_t newpos;
>  
> @@ -491,7 +491,7 @@
>  	soft->gscr_addr = mbcs_pioaddr(soft, MBCS_GSCR_START);
>  }
>  
> -int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma)
> +static int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma)
>  {
>  	struct cx_dev *cx_dev = fp->private_data;
>  	struct mbcs_soft *soft = cx_dev->soft;
> @@ -793,7 +793,7 @@
>  	return 0;
>  }
>  
> -const struct cx_device_id __devinitdata mbcs_id_table[] = {
> +static const struct cx_device_id __devinitdata mbcs_id_table[] = {
>  	{
>  	 .part_num = MBCS_PART_NUM,
>  	 .mfg_num = MBCS_MFG_NUM,
> @@ -807,7 +807,7 @@
>  
>  MODULE_DEVICE_TABLE(cx, mbcs_id_table);
>  
> -struct cx_drv mbcs_driver = {
> +static struct cx_drv mbcs_driver = {
>  	.name = DEVICE_NAME,
>  	.id_table = mbcs_id_table,
>  	.probe = mbcs_probe,
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc6-mm1/drivers/char/mbcs.h linux-2.6.22-rc6-mm1/drivers/char/mbcs.h
> --- linux.vanilla-2.6.22-rc6-mm1/drivers/char/mbcs.h	2007-07-02 20:47:23.000000000 +0100
> +++ linux-2.6.22-rc6-mm1/drivers/char/mbcs.h	2007-07-09 12:12:40.045763696 +0100
> @@ -542,12 +542,12 @@
>  	struct semaphore algolock;
>  };
>  
> -extern int mbcs_open(struct inode *ip, struct file *fp);
> -extern ssize_t mbcs_sram_read(struct file *fp, char __user *buf, size_t len,
> +static int mbcs_open(struct inode *ip, struct file *fp);
> +static ssize_t mbcs_sram_read(struct file *fp, char __user *buf, size_t len,
>  			      loff_t * off);
> -extern ssize_t mbcs_sram_write(struct file *fp, const char __user *buf, size_t len,
> +static ssize_t mbcs_sram_write(struct file *fp, const char __user *buf, size_t len,
>  			       loff_t * off);
> -extern loff_t mbcs_sram_llseek(struct file *filp, loff_t off, int whence);
> -extern int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma);
> +static loff_t mbcs_sram_llseek(struct file *filp, loff_t off, int whence);
> +static int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma);
>  
>  #endif				// __MBCS_H__

