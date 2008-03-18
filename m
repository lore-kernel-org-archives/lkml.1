Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYCRFgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYCRFgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbYCRF1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:27:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:35125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbYCRF1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:27:51 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH] thermal: fix Kconfig dependencies
Date: Tue, 18 Mar 2008 01:27:26 -0400
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
References: <20080317095845.GA6500@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803171920320.3020@woody.linux-foundation.org> <1205808029.3171.38.camel@acpi-hp-zz.sh.intel.com>
In-Reply-To: <1205808029.3171.38.camel@acpi-hp-zz.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803180127.26877.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i've reverted the offending thermal/hwmon commit,
and re-applied this documentation update to thermal.

thanks,
-Len

On Monday 17 March 2008, Zhang, Rui wrote:
> 
> On Tue, 2008-03-18 at 10:25 +0800, Linus Torvalds wrote:
> > 
> > 
> > On Mon, 17 Mar 2008, Len Brown wrote:
> > >
> > > Similarly, ACPI_THERMAL should not depend on THERMAL,
> > > instead the code that registers with THERMAL should
> > > simply depend on if THERMAL is selected or not.
> > >
> > > Also, the "default y" should go.
> > >
> > > I'll tinker with this a bit after lunch.
> > 
> > Hmm.. It looks like the same commit that caused these Kconfig issues
> > is
> > also the one that causes the problems with lmsensors
> Yes.
> >  (I didn't immediately
> > realize that it's the exact same commit).
> > 
> > I think that right now the right thing to do is to just revert it,
> > since
> > apparently there won't be a released lmsensors version by the time
> > 2.6.25
> > gets released that can handle the new sysfs layout, and that we should
> > give this some more time to be resolved.
> > 
> > So I'm inclined to revert commit
> > 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9
> > and plan on revisiting this for 2.6.26. I already got an ack for that
> > from
> > Jean Delvare, but I thought I'd mention it in this thread too before I
> > actually do the final revert.
> > 
> > Any really strong objections?
> No.
> As we still need some discussions before the problem is solved, please
> revert it. :)
> 
> And please apply this patch after reverting the old one.
> 
> thanks,
> rui
> 
> From: Zhang Rui <rui.zhang@intel.com>
> 
> The generic thermal driver shows temperature in millidegree Celsius.
> Update the documentation.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  Documentation/thermal/sysfs-api.txt |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/Documentation/thermal/sysfs-api.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/thermal/sysfs-api.txt
> +++ linux-2.6/Documentation/thermal/sysfs-api.txt
> @@ -143,10 +143,10 @@ type				Strings which represent the ther
>  				This is given by thermal zone driver as part of registration.
>  				Eg: "ACPI thermal zone" indicates it's a ACPI thermal device
>  				RO
> -				Optional
> +				Required
>  
>  temp				Current temperature as reported by thermal zone (sensor)
> -				Unit: degree Celsius
> +				Unit: millidegree Celsius
>  				RO
>  				Required
>  
> @@ -163,7 +163,7 @@ mode				One of the predefined values in 
>  					  charge of the thermal management.
>  
>  trip_point_[0-*]_temp		The temperature above which trip point will be fired
> -				Unit: degree Celsius
> +				Unit: millidegree Celsius
>  				RO
>  				Optional
>  
> @@ -193,7 +193,7 @@ type				String which represents the type
>  				eg. For memory controller device on intel_menlow platform:
>  				this should be "Memory controller"
>  				RO
> -				Optional
> +				Required
>  
>  max_state			The maximum permissible cooling state of this cooling device.
>  				RO
> @@ -219,16 +219,16 @@ the sys I/F structure will be built like
>  
>  |thermal_zone1:
>  	|-----type:			ACPI thermal zone
> -	|-----temp:			37
> +	|-----temp:			37000
>  	|-----mode:			kernel
> -	|-----trip_point_0_temp:	100
> +	|-----trip_point_0_temp:	100000
>  	|-----trip_point_0_type:	critical
> -	|-----trip_point_1_temp:	80
> +	|-----trip_point_1_temp:	80000
>  	|-----trip_point_1_type:	passive
> -	|-----trip_point_2_temp:	70
> -	|-----trip_point_2_type:	active[0]
> -	|-----trip_point_3_temp:	60
> -	|-----trip_point_3_type:	active[1]
> +	|-----trip_point_2_temp:	70000
> +	|-----trip_point_2_type:	active0
> +	|-----trip_point_3_temp:	60000
> +	|-----trip_point_3_type:	active1
>  	|-----cdev0:			--->/sys/class/thermal/cooling_device0
>  	|-----cdev0_trip_point:		1	/* cdev0 can be used for passive */
>  	|-----cdev1:			--->/sys/class/thermal/cooling_device3
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


