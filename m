Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXCTIcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXCTIcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 04:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbXCTIcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 04:32:36 -0400
Received: from aun.it.uu.se ([130.238.12.36]:49796 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbXCTIcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 04:32:35 -0400
Date: Tue, 20 Mar 2007 09:32:03 +0100 (MET)
Message-Id: <200703200832.l2K8W3o5023643@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: ak@suse.de, jesper.juhl@gmail.com
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, trent.waddington@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 18:42:22 +0100, Jesper Juhl wrote:
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4302,7 +4302,12 @@ static int __init floppy_init(void)
>  		if (err)
>  			goto out_flush_work;
>  
> -		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
> +		err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
> +		if (err)
> +			goto out_flush_work;
> +
>  		/* to be cleaned up... */
>  		disks[drive]->private_data = (void *)(long)drive;
>  		disks[drive]->queue = floppy_queue;

The floppy driver's sysfs file just provides some auxiliary
information to user-space, none of which matters for most of
its users. It is IMO totally inappropriate to fail floppy
driver init in this case.

/Mikael
