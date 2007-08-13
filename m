Return-Path: <linux-kernel-owner+w=401wt.eu-S943643AbXHMP1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943643AbXHMP1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972883AbXHMNW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:22:28 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:4287 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S972197AbXHMNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:22:25 -0400
Date: Mon, 13 Aug 2007 15:22:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Markus Rechberger" <markus.rechberger@amd.com>
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Firmware class name collision
Message-ID: <20070813152251.032fb302@hyperion.delvare>
In-Reply-To: <46C05896.4050509@amd.com>
References: <46C05896.4050509@amd.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On Mon, 13 Aug 2007 15:11:50 +0200, Markus Rechberger wrote:
> following patch fixes the i2c name collision with i2c-dev.
> 
> http://mcentral.de/wiki/index.php/Bugtracker#i2c_core_problem
> 
> This issue has been experienced with em28xx and saa7133 based devices.
> I discussed that problem with Jean Delvare a while ago and he proposed 
> to add a prefix to the class name.
> 
> http://mcentral.de/~mrec/patches/firmware_class_name_collision.diff
> 
> Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

> 
> index b24efd4..bfc54a1 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -297,8 +297,7 @@ firmware_class_timeout(u_long data)
>  
>  static inline void fw_setup_device_id(struct device *f_dev, struct 
> device *dev)
>  {
> -       /* XXX warning we should watch out for name collisions */
> -       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
> +       snprintf(f_dev->bus_id, BUS_ID_SIZE, "fw-%s", dev->bus_id);
>  }
>  
>  static int fw_register_device(struct device **dev_p, const char *fw_name,


-- 
Jean Delvare
