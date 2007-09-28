Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbXI1UdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbXI1UdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXI1Ucf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:32:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33381 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbXI1Ucc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:32:32 -0400
Date: Fri, 28 Sep 2007 13:32:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Sumant.patro@lsi.com
Subject: Re: PATCH [2/8] scsi: megaraid_sas - add module param fast_load
Message-Id: <20070928133218.e3f07a60.randy.dunlap@oracle.com>
In-Reply-To: <1190820130.5955.7.camel@dhcp-75-534.se.lsil.com>
References: <1190820130.5955.7.camel@dhcp-75-534.se.lsil.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 11:22:10 -0400 bo yang wrote:

> Driver will skip physical devices scan for the first time if the fast_load is set. This is to reduce time for loading driver.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   69 +++++++++++++++++++------
>  1 files changed, 55 insertions(+), 14 deletions(-)
> 
> diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-09-26 16:19:18.321402040 -0400
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-09-26 16:20:52.915021624 -0400
> @@ -46,6 +46,22 @@
>  #include <scsi/scsi_host.h>
>  #include "megaraid_sas.h"
>  
> +/*
> + * Module parameters
> + */
> +
> +/*
> + * Fast driver load option, skip scanning for physical devices during
> + * load.  This would result in physical devices being skipped during
> + * driver load time. These can be later added though,
> + * using /proc/scsi/scsi
> + */
> +static unsigned int fast_load;
> +module_param_named(fast_load, fast_load, int, 0);
> +MODULE_PARM_DESC(fast_load,
> +	"megasas: Faster loading of the driver, skips physical devices! \
> +	 (default = 0)");

The continuation line begins with an unwanted tab that is inside the
"string".  How about like this?  (untested)


MODULE_PARM_DESC(fast_load,
	"megasas: Faster loading of the driver, skips physical devices! "\
	"(default = 0)");


> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux@lsi.com");


---
~Randy
Phaedrus says that Quality is about caring.
