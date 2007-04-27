Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbXD0Vab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbXD0Vab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbXD0Vab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:30:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38579 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757330AbXD0Vaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:30:30 -0400
Date: Fri, 27 Apr 2007 22:34:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds@osdl.org
Subject: Re: Driver core: warn when userspace writes to the uevent file in a
 non-supported way
Message-ID: <20070427223411.01cfecae@the-village.bc.nu>
In-Reply-To: <200704272059.l3RKxUYn024215@hera.kernel.org>
References: <200704272059.l3RKxUYn024215@hera.kernel.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>     In the future we will allow the uevent type to be written to the uevent
>     file to trigger the different types of uevents.  But for now, as we only
>     support the ADD event, warn if userspace tries to write anything else to
>     this file.
>     
>     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/base/core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 72c6ee5..f69305c 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -296,6 +296,9 @@ out:
>  static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
>  			    const char *buf, size_t count)
>  {
> +	if (memcmp(buf, "add", 3) != 0)
> +		dev_err(dev, "uevent: unsupported action-string; this will "
> +			"be ignored in a future kernel version");

Warnings good, lack of rate limiting extremely bad indeed.
