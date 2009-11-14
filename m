Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZKNP0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZKNP0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 10:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZKNP0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 10:26:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44626 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753173AbZKNP03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 10:26:29 -0500
Date: Sat, 14 Nov 2009 15:28:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrey Polovov <andrey.polovov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting HDD serial in kernel space
Message-ID: <20091114152826.014cfc35@lxorguk.ukuu.org.uk>
In-Reply-To: <4AFE95DE.3070308@gmail.com>
References: <4AFE95DE.3070308@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Nov 2009 14:34:54 +0300
Andrey Polovov <andrey.polovov@gmail.com> wrote:

> Hello.
> 
> I had a necessity to get HDD serial number in my kernel module.
> In user space I can do it so:
> 
>     fd = open( "/dev/sda", O_RDONLY|O_NONBLOCK );
>     ioctl( fd, HDIO_GET_IDENTITY, &id );
>     printf( "Serial: %s", id.serial_no );
> 
> How can I do it in kernel space (it is one hdd in machine, plugged with
> SATA)?

The identity when probed is all in the struct ata_device, although be
aware that it may not be unique per device and also that hotplug means
you need to be careful how you access it. Now and then you meet a device
where the serial number changes randomly each boot just to really annoy.

What are you actually trying to do ?
