Return-Path: <linux-kernel-owner+w=401wt.eu-S934362AbZLPBCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362AbZLPBCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbZLPBCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:02:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:8229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934346AbZLPBCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:02:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,402,1257148800"; 
   d="scan'208";a="756551511"
Subject: Re: [PATCH] thermal: Fix test of unsigned in
 thermal_cooling_device_cur_state_store()
From: Zhang Rui <rui.zhang@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Brown, Len" <len.brown@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <4B2803CA.5020101@gmail.com>
References: <4B2803CA.5020101@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 09:05:16 +0800
Message-ID: <1260925516.1839.4.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 05:46 +0800, Roel Kluin wrote:
> state is unsigned long so the test did not work.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Zhang Rui <rui.zhang@intel.com>

> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
> 
> Is this the best way to fix this?
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 6f8d8f9..800e0c5 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -374,7 +374,7 @@ thermal_cooling_device_cur_state_store(struct device *dev,
>  	if (!sscanf(buf, "%ld\n", &state))
>  		return -EINVAL;
>  
> -	if (state < 0)
> +	if ((long)state < 0)
>  		return -EINVAL;
>  
>  	result = cdev->ops->set_cur_state(cdev, state);


