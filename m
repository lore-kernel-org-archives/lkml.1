Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXL2LnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXL2LnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 06:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXL2LnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 06:43:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54103 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbXL2LnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 06:43:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <477632AC.2000502@s5r6.in-berlin.de>
Date: Sat, 29 Dec 2007 12:42:36 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: krh@redhat.com, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/12] firewire : Use mutex instead of semaphore in driver
 core
References: <20071229010602.GD2883@darkstar.te-china.tietoenator.com>
In-Reply-To: <20071229010602.GD2883@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> --- linux/drivers/firewire/fw-device.c	2007-12-28 10:02:38.000000000 +0800
> +++ linux.new/drivers/firewire/fw-device.c	2007-12-28 10:05:00.000000000 +0800
> @@ -26,7 +26,7 @@
>  #include <linux/delay.h>
>  #include <linux/idr.h>
>  #include <linux/rwsem.h>
> -#include <asm/semaphore.h>
> +#include <linux/mutex.h>
>  #include <linux/ctype.h>
>  #include "fw-transaction.h"
>  #include "fw-topology.h"
> @@ -731,9 +731,9 @@ static int update_unit(struct device *de
>  	struct fw_driver *driver = (struct fw_driver *)dev->driver;
>  
>  	if (is_fw_unit(dev) && driver != NULL && driver->update != NULL) {
> -		down(&dev->sem);
> +		mutex_lock(&dev->mutex);
>  		driver->update(unit);
> -		up(&dev->sem);
> +		mutex_unlock(&dev->mutex);
>  	}
>  
>  	return 0;

ACK to this part of the series.
-- 
Stefan Richter
-=====-=-=== ==-- ===-=
http://arcgraph.de/sr/
