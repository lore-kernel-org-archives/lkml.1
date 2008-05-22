Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbYEVUxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbYEVUxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbYEVUww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:52:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3974 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbYEVUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:52:51 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5301"; a="3160867"
Message-ID: <4835DD1D.1040102@qualcomm.com>
Date: Thu, 22 May 2008 13:52:45 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] hci_vhci: Elimiate BKL from ioctl handling
References: <20080522213020.498327ed@core>
In-Reply-To: <20080522213020.498327ed@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Switch to unlocked_ioctl and fix the return value to be -ENOTTY as it
> should be.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
> index 0638730..41002ef 100644
> --- a/drivers/bluetooth/hci_vhci.c
> +++ b/drivers/bluetooth/hci_vhci.c
> @@ -245,10 +245,9 @@ static unsigned int vhci_poll(struct file *file, poll_table *wait)
>  	return POLLOUT | POLLWRNORM;
>  }
>  
> -static int vhci_ioctl(struct inode *inode, struct file *file,
> -					unsigned int cmd, unsigned long arg)
> +static long vhci_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> -	return -EINVAL;
> +	return -ENOTTY;
>  }
>  
>  static int vhci_open(struct inode *inode, struct file *file)
> @@ -332,7 +331,7 @@ static const struct file_operations vhci_fops = {
>  	.read		= vhci_read,
>  	.write		= vhci_write,
>  	.poll		= vhci_poll,
> -	.ioctl		= vhci_ioctl,
> +	.unlocked_ioctl	= vhci_ioctl,
>  	.open		= vhci_open,
>  	.release	= vhci_release,
>  	.fasync		= vhci_fasync,
> 

Ack.

CC'ing Marcel.

Max
