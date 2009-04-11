Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZDKBw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZDKBw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZDKBwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:52:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:13480 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbZDKBwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=En+8BRniNiYwi3wU87H09GJ61uArt+sWqItvCzghKu2kpxsIoDbvi1S+fOZEccO3Nv
         nEPWi0PIBApVm3ARo9NgxkGWECrSXGpzXgfl38Rx1yY381CNVDV4mB6z4D3Zp7vHSX1i
         c1FfdpyUqmfjm0ag5fR1+mz+hmfZNAEmdH1Tk=
MIME-Version: 1.0
In-Reply-To: <m2fxggle43.fsf@igel.home>
References: <1232551667-4829-1-git-send-email-tom.leiming@gmail.com>
	 <m2fxggle43.fsf@igel.home>
Date: Sat, 11 Apr 2009 09:52:16 +0800
Message-ID: <d82e647a0904101852h7f41492epad2226f29124452d@mail.gmail.com>
Subject: Re: [PATCH] driver core: check bus->match without holding device 
	lock(v2)
From: Ming Lei <tom.leiming@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: kay.sievers@vrfy.org, greg@kroah.com, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/10 Andreas Schwab <schwab@linux-m68k.org>:
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index ddc9749..087e911 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -115,7 +115,7 @@ extern int driver_probe_device(struct device_driver *drv, struct device *dev);
>  static inline int driver_match_device(struct device_driver *drv,
>                                      struct device *dev)
>  {
> -       return drv->bus->match && drv->bus->match(dev, drv);
> +       return !drv->bus->match || drv->bus->match(dev, drv);
>  }

A similar patch has been in greg's tree:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core.current/driver-core-fix-driver_match_device.patch

Thanks!

-- 
Lei Ming
