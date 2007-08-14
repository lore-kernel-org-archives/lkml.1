Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXHNNdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXHNNdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbXHNNdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:33:13 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:52110 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbXHNNdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:33:12 -0400
Date: Tue, 14 Aug 2007 15:33:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Markus Rechberger" <markus.rechberger@amd.com>
Cc: "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Firmware class name collision
Message-ID: <20070814153340.4f844f5a@hyperion.delvare>
In-Reply-To: <46C092EB.1070501@amd.com>
References: <46C05896.4050509@amd.com>
	<1187025047.6698.219.camel@violet>
	<46C092EB.1070501@amd.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On Mon, 13 Aug 2007 19:20:43 +0200, Markus Rechberger wrote:
> Marcel Holtmann wrote:
> > I would prefer if we use "firmware-%s" since the "fw" might collide with
> > the new Firewire stack. Please change that and I agree.
> 
> firmware-%s sounds more informative and cannot be mistaken with firewire 
> yes.
> 
> Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
> 
> http://mcentral.de/~mrec/patches/firmware_class_name_collision_2.diff
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
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
> +       snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s", dev->bus_id);
>  }

Please keep in mind that BUS_ID_SIZE is "only" 20. "firmware-" takes 9
characters, add one for the trailing zero and this only leaves room for
10 characters for the original bus id. While this will be enough for
the i2c case, I suspect that some other bus IDs won't fit. 

-- 
Jean Delvare
