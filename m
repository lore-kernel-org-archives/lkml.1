Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbXI1VbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbXI1VbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbXI1Vaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:30:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56865 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXI1Vau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:30:50 -0400
Message-ID: <46FD727C.3090008@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2007 16:30:36 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: bo yang <bo.yang@lsi.com>
CC: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Sumant.patro@lsi.com
Subject: Re: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors,
 cmd_per_lun
References: <1190820470.5955.12.camel@dhcp-75-534.se.lsil.com>
In-Reply-To: <1190820470.5955.12.camel@dhcp-75-534.se.lsil.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bo yang wrote:

> +static ssize_t
> +sysfs_max_sectors_read(struct kobject *kobj,
> +			struct bin_attribute *bin_attr,
> +			char *buf, loff_t off, size_t count)
> +{
> +	struct Scsi_Host *host = class_to_shost(container_of(kobj,
> +					struct class_device, kobj));
> +	struct megasas_instance *instance =
> +				(struct megasas_instance *)host->hostdata;
> +
> +	count = sprintf(buf, "%u\n", instance->max_sectors_per_req);
> +
> +	return count+1;
> +}
> +
> +static struct bin_attribute sysfs_max_sectors_attr = {
> +	.attr = {
> +		.name = "max_sectors",
> +		.mode = S_IRUSR|S_IRGRP|S_IROTH,
> +		.owner = THIS_MODULE,
> +	},
> +	.size = 7,
> +	.read = sysfs_max_sectors_read,
> +};

Why is this implemented as a binary sysfs attribute? Also, can you use
the existing shost_attrs infrastructure that's in the scsi_host_template
like megaraid_mbox uses?


> +
> +	/*
> +	 * Check if the module parameter value for max_sectors can be used
> +	 */
> +	if (max_sectors && max_sectors <= instance->max_sectors_per_req)
> +		instance->max_sectors_per_req = max_sectors;
> +	else {
> +		if (max_sectors)
> +			printk(KERN_INFO
> +				"megasas: max_sectors should be > 0 and"
> +				"<= %d\n",
> +				instance->max_sectors_per_req);
> +	}

Could be simplified to an else if, which would remove one indent level...

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
