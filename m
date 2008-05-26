Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYEZIz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYEZIz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYEZIzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:55:20 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51628 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYEZIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:55:18 -0400
Date: Mon, 26 May 2008 10:55:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-usb@vger.kernel.org, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] hiddev: Switch to unlocked_ioctl
In-Reply-To: <20080522222217.3a785487@core>
Message-ID: <Pine.LNX.4.64.0805261053090.18218@twin.jikos.cz>
References: <20080522222217.3a785487@core>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Alan Cox wrote:

> Push down the BKL. In some cases compat_ioctl already doesn't take the
> BKL so we don't either. 

Thanks.

> @@ -555,7 +559,10 @@ static int hiddev_ioctl(struct inode *inode, struct file *file, unsigned int cmd
>  	struct usbhid_device *usbhid = hid->driver_data;
>  	void __user *user_arg = (void __user *)arg;
>  	int i;
> +	
> +	/* Called without BKL by compat methods so no BKL taken */
>  
> +	/* FIXME: Who or what stop this racing with a disconnect ?? */
>  	if (!hiddev->exist)
>  		return -EIO;

Oliver (added to CC) -- I vaguely remember you already fixing this race, 
but I don't seem to be able to find the patch anywhere. Do I just remember 
incorrectly?

Thanks,

-- 
Jiri Kosina
