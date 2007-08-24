Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXHXFD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXHXFD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 01:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXHXFDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 01:03:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:49287 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbXHXFDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 01:03:49 -0400
Subject: Re: [patch 04/14] Convert from class_device to device for
	drivers/macintosh
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: tonyj@suse.de
Cc: linux-kernel@vger.kernel.org, funaho@jurai.org, kay.sievers@vrfy.org
In-Reply-To: <20070820225101.782694000@suse.de>
References: <20070820224806.154198000@suse.de>
	 <20070820225101.782694000@suse.de>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 07:04:22 +0200
Message-Id: <1187931862.5972.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 15:48 -0700, tonyj@suse.de wrote:
> -- 
> Content-Disposition: inline; filename=macintosh.patch
> 
> Convert from class_device to device for macintosh.  This is part of the
> work to eliminate struct class_device.

Good. That stuff shouldn't have been a class in the first place. ADB is
a bus type, not a class.

Ben.

> ---
>  drivers/macintosh/adb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/macintosh/adb.c
> +++ b/drivers/macintosh/adb.c
> @@ -875,5 +875,5 @@ adbdev_init(void)
>  	adb_dev_class = class_create(THIS_MODULE, "adb");
>  	if (IS_ERR(adb_dev_class))
>  		return;
> -	class_device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), NULL, "adb");
> +	device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), "adb");
>  }
> 

