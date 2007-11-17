Return-Path: <linux-kernel-owner+w=401wt.eu-S935355AbXKQBTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355AbXKQBTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 20:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbXKQBTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 20:19:24 -0500
Received: from aun.it.uu.se ([130.238.12.36]:34397 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbXKQBTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 20:19:24 -0500
Date: Sat, 17 Nov 2007 02:15:05 +0100 (MET)
Message-Id: <200711170115.lAH1F5kZ009153@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, timur@freescale.com
Subject: Re: Add a private_data pointer to struct device_attribute
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 18:11:00 -0600, Timur Tabi wrote:
> A private data pointer in struct device_attribute allows the 'show' and 'store'
> functions to access instance data.  This handy in situations where the
> driver_data and platform_data pointers of 'struct device' are already used
> for other purposes.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> 
> Greg, can you tell me if you think this patch is a good idea?  It doesn't
> appear to do any harm, and I'm working on an ALSA driver that could benefit
> for this patch.  I think 2.6.25 would be a good target.
> 
>  include/linux/device.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 2e15822..10708ee 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -344,6 +344,7 @@ struct device_attribute {
>  			char *buf);
>  	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
>  			 const char *buf, size_t count);
> +	void *private_data;
>  };

A common trick is to embed a generic struct inside a specific one
containing add-on data fields, and then to map from the generic
one to the specific one using container_of() in your ops (function
pointers). This is both faster and less wasteful of memory than
adding void *private all over the place.

Any reason that won't work here?
