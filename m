Return-Path: <linux-kernel-owner+w=401wt.eu-S1030634AbXD1NAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbXD1NAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031160AbXD1NAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:00:40 -0400
Received: from main.gmane.org ([80.91.229.2]:47394 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030634AbXD1NAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:00:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Date: Sat, 28 Apr 2007 13:00:14 +0000 (UTC)
Message-ID: <pan.2007.04.28.13.00.14@free.fr>
References: <20070427224957.GA17967@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cac94-1-81-57-151-96.fbx.proxad.net
User-Agent: Pan/0.125 (Potzrebie)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 27 Apr 2007 15:49:57 -0700, Greg KH wrote:

> Here are the updated UIO (Userspace I/O driver framework) patches for
> 2.6.21.
> 

> 
>  Documentation/DocBook/kernel-api.tmpl |    4 +
>  Documentation/DocBook/uio-howto.tmpl  |  498 +++++++++++++++++++++++
>  drivers/Kconfig                       |    1 + drivers/Makefile        
>               |    1 + drivers/uio/Kconfig                   |   27 ++
>  drivers/uio/Makefile                  |    2 + drivers/uio/uio.c       
>               |  702 +++++++++++++++++++++++++++++++++
>  drivers/uio/uio_cif.c                 |  156 ++++++++
>  include/linux/uio_driver.h            |   91 +++++ 9 files changed,
>  1482 insertions(+), 0 deletions(-) create mode 100644
>  Documentation/DocBook/uio-howto.tmpl create mode 100644
>  drivers/uio/Kconfig create mode 100644 drivers/uio/Makefile create mode
>  100644 drivers/uio/uio.c
>  create mode 100644 drivers/uio/uio_cif.c create mode 100644
>  include/linux/uio_driver.h
> 
uio_dummy.c (that should be present according documentation) seems 
missing.

I find the doc not very clear for the devices where there is no 
interrupt : they speak of some kernel timer, but a userspace timer could 
be used (and even the userspace driver could be written without kernel 
support at all).

At the end of the doc there is something about IRQ_HANDLED vs IRQ_NONE.
Last time I check kernel irq code, in both case next irq handler are 
called. The only difference was that if all handler reply IRQ_NONE, the 
kernel gave an error about an unexpected interrupt.

Also why sysfs is used for describing the mapping instead of something 
like an ioctl ?
UIO could be useful in embedded system where sysfs is not always 
desirable.


Matthieu

