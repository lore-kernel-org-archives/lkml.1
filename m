Return-Path: <linux-kernel-owner+w=401wt.eu-S933608AbZJFWTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbZJFWTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933593AbZJFWTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58820 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933575AbZJFWTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:19:15 -0400
Date: Tue, 6 Oct 2009 23:19:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, greg@kroah.com,
       charles.f.johnson@intel.com, Mark Allyn <mark.a.allyn@intel.com>
Subject: Re: [PATCH] Integrating SEP Driver with RAR Driver
Message-ID: <20091006231955.003932b7@lxorguk.ukuu.org.uk>
In-Reply-To: <1254861977-18123-1-git-send-email-mark.a.allyn@intel.com>
References: <1254861977-18123-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define SEP_IOCTLSETCALLERID                   _IO(SEP_IOC_MAGIC_NUMBER , 33)

_IOR _IOW etc... I pointed this out before and it's not fixed


>  struct sep_driver_realloc_cache_resident_t {
> -	/* new cache address */
> -	u64 new_cache_addr;
> -	/* new resident address */
> -	u64 new_resident_addr;
> -	/* new resident address */
> -	u64  new_shared_area_addr;
> -	/* new base address */
> -	u64 new_base_addr;
> -};
> +  /* base address */
> +  unsigned long   base_addr;

and the ioctls still need to be fixed for 32/64bit


> +/* debug macro with 3 paramaters */
> +#define DEBUG_PRINT_3(DEBUG_LEVEL, info, param1, param2, param3) \
> +do { \
> +	if (DEBUG_LEVEL & sepDebug) \
> +		printk(KERN_WARNING info , param1, param2 , param3); \
> +} while (0)

And the debug helpers are a step back

Sorry but this is basically undoing a lot of cleanup that was needed.


To put it mildly this needs a lot of further discussion before anything
goes into the code.
