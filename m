Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0CEUhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:37:16 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:47747 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751430Ab0CEUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:37:12 -0500
Message-ID: <4B916B7F.4000204@suse.de>
Date: Fri, 05 Mar 2010 23:37:19 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH -mmotm] acpi/sbs: fix build for ACPI_SYSFS_POWER=n
References: <201003050232.o252WD4K011798@imap1.linux-foundation.org> <4B916169.5040303@oracle.com>
In-Reply-To: <4B916169.5040303@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Randy Dunlap пишет:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_ACPI_SYSFS_POWER is not enabled:
> 
> drivers/acpi/sbs.c:640: error: implicit declaration of function 'acpi_battery_get_alarm'
> drivers/acpi/sbs.c:679: error: implicit declaration of function 'acpi_battery_set_alarm'
> 
> 
> so move those functions outside of the ifdef/endif block for that
> config option.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> ---
>  drivers/acpi/sbs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- mmotm-2010-0304-1805.orig/drivers/acpi/sbs.c
> +++ mmotm-2010-0304-1805/drivers/acpi/sbs.c
> @@ -412,8 +412,6 @@ static int acpi_ac_get_present(struct ac
>  	return result;
>  }
>  
> -#ifdef CONFIG_ACPI_SYSFS_POWER
> -
>  static int acpi_battery_get_alarm(struct acpi_battery *battery)
>  {
>  	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
> @@ -450,6 +448,8 @@ static int acpi_battery_set_alarm(struct
>  	return ret;
>  }
>  
> +#ifdef CONFIG_ACPI_SYSFS_POWER
> +
>  static ssize_t acpi_battery_alarm_show(struct device *dev,
>  					struct device_attribute *attr,
>  					char *buf)

