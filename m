Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbXJCVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbXJCVqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbXJCVqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:46:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16343 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbXJCVqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:46:42 -0400
Date: Wed, 3 Oct 2007 14:00:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com
Subject: Re: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors,
 cmd_per_lun
Message-Id: <20071003140038.7e9a3a1b.randy.dunlap@oracle.com>
In-Reply-To: <1191253908.5850.12.camel@dhcp-75-534.se.lsil.com>
References: <1191253908.5850.12.camel@dhcp-75-534.se.lsil.com>
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

On Mon, 01 Oct 2007 11:51:48 -0400 bo yang wrote:

> Adding module parameters to configure max sectors per request & # of cmds per lun.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   68 ++++++++++++++++++++++++-
>  drivers/scsi/megaraid/megaraid_sas.h |    2
>  2 files changed, 68 insertions(+), 2 deletions(-)
> 
> diff -uprN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-10-01 00:14:29.000000000 -0700
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-10-01 02:15:16.000000000 -0700
> @@ -62,6 +62,23 @@ MODULE_PARM_DESC(fast_load,
>  	"megasas: Faster loading of the driver, skips physical devices! "\
>  	"(default = 0)");
>  
> +/*
> + * Number of sectors per IO command will be set in megasas_init_mfi
> + * if user does not provide
> + */
> +static unsigned int max_sectors;
> +module_param_named(max_sectors, max_sectors, int, 0);
> +MODULE_PARM_DESC(max_sectors,
> +	"Maximum number of sectors per IO command");

Are you sure that you want these parameters hidden (permission = 0)
instead of readable via sysfs?

(same applies to the fast_load parameter patch also)


> +/*
> + * Number of cmds per logical unit
> + */
> +static unsigned int cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
> +module_param_named(cmd_per_lun, cmd_per_lun, int, 0);
> +MODULE_PARM_DESC(cmd_per_lun,
> +	"Maximum number of commands per logical unit (default=128)");
> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux@lsi.com");


---
~Randy
