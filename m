Return-Path: <linux-kernel-owner+w=401wt.eu-S1032332AbXHMRTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032332AbXHMRTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944611AbXHMRI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:08:59 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:42410 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbXHMRI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:08:56 -0400
Subject: Re: [PATCH] Firmware class name collision
From: Marcel Holtmann <marcel@holtmann.org>
To: Markus Rechberger <markus.rechberger@amd.com>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <46C05896.4050509@amd.com>
References: <46C05896.4050509@amd.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 19:10:47 +0200
Message-Id: <1187025047.6698.219.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

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

I would prefer if we use "firmware-%s" since the "fw" might collide with
the new Firewire stack. Please change that and I agree.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


