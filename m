Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbYA0TnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbYA0TnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbYA0Tmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:42:55 -0500
Received: from mail.suse.de ([195.135.220.2]:41254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130AbYA0Tmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:42:54 -0500
Date: Sun, 27 Jan 2008 11:41:16 -0800
From: Greg KH <gregkh@suse.de>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 158/196] Driver core: convert block from raw kobjects
Message-ID: <20080127194116.GB17136@suse.de>
References: <20080125232317.GA7131@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125232317.GA7131@mailshack.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 12:23:18AM +0100, Alexander van Heukelum wrote:
> Fix build with CONFIG_BLOCK off.
> 
> Building git-2d94dfc with CONFIG_BLOCK turned off gives me:
> 
> drivers/base/core.c: In function 'device_add_class_symlinks':
> drivers/base/core.c:704: error: 'part_type' undeclared (first use in this function)
> drivers/base/core.c:704: error: (Each undeclared identifier is reported only once
> drivers/base/core.c:704: error: for each function it appears in.)
> drivers/base/core.c: In function 'device_remove_class_symlinks':
> drivers/base/core.c:743: error: 'part_type' undeclared (first use in this function)
> 
> git-blame points to Kay Sievers.
> 
> The problem is obvious. I think te solution is too ;).
> 
> Tested with a silly configuration that contains just enough wits to boot
> and get to the prompt of klibc-dash on the built-in initramfs using:
>    qemu -m 8 -cpu pentium -serial stdio -cdrom arch/x86/boot/image.iso
> 
> Compile-tested i386-defconfig.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> Oh, and the compile-problem still exists in git-99f1c97. The git-tree is
> changing faster than I can test the patch and write an e-mail :-/.
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index edf3bbe..3751843 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -75,6 +75,15 @@ static ssize_t dev_attr_store(struct kobject *kobj, struct attribute *attr,
>  	return ret;
>  }
>  
> +static int dev_needs_link(struct device *dev)
> +{
> +#ifdef CONFIG_BLOCK
> +	return dev->type != &part_type;
> +#else
> +	return 1;
> +#endif
> +}

Ick.  Close, but still messy, let me try to do something cleaner here...

thanks,

greg k-h
