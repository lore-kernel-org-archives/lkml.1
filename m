Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476Ab0AMT35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0AMT35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043Ab0AMT34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:29:56 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37594 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab0AMT3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:29:55 -0500
Date: Wed, 13 Jan 2010 11:29:47 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/acpi/power_meter.c : remove double kfree()
Message-ID: <20100113192947.GZ10295@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <1263299827.4571.11.camel@ICE-BOX>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263299827.4571.11.camel@ICE-BOX>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 11:37:07PM +1100, Darren Jenkins wrote:
> resource->domain_devices can be double kfree()'d in a couple of places.
> Fix this by setting num_domain_devices = 0 after the kfree().
> 
> Coverity CID: 13356, 13355, 13354
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com> 

Thanks for catching this.

Acked-by: Darrick J. Wong <djwong@us.ibm.com>

> 
> diff --git drivers/acpi/power_meter.c drivers/acpi/power_meter.c
> index 2ef7030..18ce00a 100644
> --- drivers/acpi/power_meter.c
> +++ drivers/acpi/power_meter.c
> @@ -534,6 +534,7 @@ static void remove_domain_devices(struct acpi_power_meter_resource *resource)
> 
>  	kfree(resource->domain_devices);
>  	kobject_put(resource->holders_dir);
> +	resource->num_domain_devices = 0;
>  }
> 
>  static int read_domain_devices(struct acpi_power_meter_resource *resource)
> @@ -740,7 +741,6 @@ skip_unsafe_cap:
> 
>  	return res;
>  error:
> -	remove_domain_devices(resource);
>  	remove_attrs(resource);
>  	return res;
>  }
> 
> 
