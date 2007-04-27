Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbXD0VhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbXD0VhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbXD0VhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:37:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51125 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757344AbXD0VhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:37:18 -0400
Date: Fri, 27 Apr 2007 22:41:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Driver core: warn when userspace writes to the uevent file in a
 non-supported way
Message-ID: <20070427224104.386d8eab@the-village.bc.nu>
In-Reply-To: <200704272059.l3RKxUYn024215@hera.kernel.org>
References: <200704272059.l3RKxUYn024215@hera.kernel.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -296,6 +296,9 @@ out:
>  static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
>  			    const char *buf, size_t count)
>  {
> +	if (memcmp(buf, "add", 3) != 0)
> +		dev_err(dev, "uevent: unsupported action-string; this will "
> +			"be ignored in a future kernel version");
>  	kobject_uevent(&dev->kobj, KOBJ_ADD);
>  	return count;
>  }


And checking for "add" without actually checking if count >= 3 is very
ugly style indeed. Not afaict any kind of security risk as the next 3
bytes are always going to be readable
