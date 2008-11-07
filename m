Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYKGB5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYKGB5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYKGB4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:56:45 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:52163 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYKGB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:56:44 -0500
Date: Thu, 06 Nov 2008 20:30:17 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] 3/3 intel_menlow: syncing with acpi function changes
In-reply-to: <7D0189F5BE1DF549A570B212D1D5612182AF07@bgsmsx412.gar.corp.intel.com>
X-X-Sender: lenb@localhost.localdomain
To: "Thomas, Sujith" <sujith.thomas@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811062029190.3106@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <7D0189F5BE1DF549A570B212D1D5612182AF07@bgsmsx412.gar.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sujith,

AFAICS, this patch is already applied.
since the e-mail is line-wrapped, it is tedious to verify,
let me know if i'm wrong.

thanks,
-Len


On Wed, 5 Nov 2008, Thomas, Sujith wrote:

> 4th parameter of acpi_evaluate_integer changed to unsigned long long
> acpi_driver_data() changed to inline function from macro
> 
> Signed-off-by: Sujith Thomas <sujith.thomas@intel.com>
> ---
>  drivers/misc/intel_menlow.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6.27/drivers/misc/intel_menlow.c
> ===================================================================
> --- linux-2.6.27.orig/drivers/misc/intel_menlow.c
> +++ linux-2.6.27/drivers/misc/intel_menlow.c
> @@ -62,7 +62,7 @@ static int memory_get_int_max_bandwidth(
>  {
>  	struct acpi_device *device = cdev->devdata;
>  	acpi_handle handle = device->handle;
> -	unsigned long value;
> +	unsigned long long value;
>  	struct acpi_object_list arg_list;
>  	union acpi_object arg;
>  	acpi_status status = AE_OK;
> @@ -98,7 +98,7 @@ static int memory_get_cur_bandwidth(stru
>  {
>  	struct acpi_device *device = cdev->devdata;
>  	acpi_handle handle = device->handle;
> -	unsigned long value;
> +	unsigned long long value;
>  	struct acpi_object_list arg_list;
>  	union acpi_object arg;
>  	acpi_status status = AE_OK;
> @@ -112,7 +112,7 @@ static int memory_get_cur_bandwidth(stru
>  	if (ACPI_FAILURE(status))
>  		return -EFAULT;
>  
> -	return sprintf(buf, "%ld\n", value);
> +	return sprintf(buf, "%lld\n", value);
>  }
>  
>  static int memory_set_cur_bandwidth(struct thermal_cooling_device
> *cdev,
> @@ -139,7 +139,7 @@ static int memory_set_cur_bandwidth(stru
>  
>  	status =
>  	    acpi_evaluate_integer(handle, MEMORY_SET_BANDWIDTH,
> &arg_list,
> -				  (unsigned long *)&temp);
> +				  (unsigned long long *)&temp);
>  
>  	printk(KERN_INFO
>  	       "Bandwidth value was %d: status is %d\n", state, status);
> @@ -183,7 +183,7 @@ static int intel_menlow_memory_add(struc
>  		goto end;
>  	}
>  
> -	acpi_driver_data(device) = cdev;
> +	device->driver_data = cdev;
>  	result = sysfs_create_link(&device->dev.kobj,
>  				&cdev->device.kobj, "thermal_cooling");
>  	if (result)
> @@ -268,7 +268,7 @@ static int sensor_get_auxtrip(acpi_handl
>  		return -EINVAL;
>  
>  	status = acpi_evaluate_integer(handle, index ? GET_AUX1 :
> GET_AUX0,
> -				       NULL, (unsigned long *)value);
> +				       NULL, (unsigned long long
> *)value);
>  	if (ACPI_FAILURE(status))
>  		return -EIO;
>  
> @@ -296,7 +296,7 @@ static int sensor_set_auxtrip(acpi_handl
>  		return -EINVAL;
>  
>  	status = acpi_evaluate_integer(handle, index ? GET_AUX0 :
> GET_AUX1,
> -				       NULL, (unsigned long *)&temp);
> +				       NULL, (unsigned long long
> *)&temp);
>  	if (ACPI_FAILURE(status))
>  		return -EIO;
>  	if ((index && value < temp) || (!index && value > temp))
> @@ -304,7 +304,7 @@ static int sensor_set_auxtrip(acpi_handl
>  
>  	arg.integer.value = value;
>  	status = acpi_evaluate_integer(handle, index ? SET_AUX1 :
> SET_AUX0,
> -				       &args, (unsigned long *)&temp);
> +				       &args, (unsigned long long
> *)&temp);
>  	if (ACPI_FAILURE(status))
>  		return -EIO;
>  
> @@ -384,7 +384,7 @@ static ssize_t bios_enabled_show(struct 
>  				 struct device_attribute *attr, char
> *buf)
>  {
>  	acpi_status status;
> -	unsigned long bios_enabled;
> +	unsigned long long bios_enabled;
>  
>  	status = acpi_evaluate_integer(NULL, BIOS_ENABLED, NULL,
> &bios_enabled);
>  	if (ACPI_FAILURE(status))
> @@ -500,7 +500,7 @@ static int __init intel_menlow_module_in
>  {
>  	int result = -ENODEV;
>  	acpi_status status;
> -	unsigned long enable;
> +	unsigned long long enable;
>  
>  	if (acpi_disabled)
>  		return result;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
