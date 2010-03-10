Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab0CJQg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 11:36:26 -0500
Received: from xenotime.net ([72.52.64.118]:40743 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756841Ab0CJQgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 11:36:25 -0500
Message-ID: <4B97CA84.1050606@xenotime.net>
Date: Wed, 10 Mar 2010 08:36:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] Driver core: Early platform kernel-doc update
References: <20100310115038.21785.46115.sendpatchset@t400s>
In-Reply-To: <20100310115038.21785.46115.sendpatchset@t400s>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/10 03:50, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> This patch updates the kernel-doc notation for early
> platform functions.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks much.

> ---
> 
>  drivers/base/platform.c |   27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 
> --- 0001/drivers/base/platform.c
> +++ work/drivers/base/platform.c	2010-03-10 20:45:06.000000000 +0900
> @@ -1052,9 +1052,11 @@ static __initdata LIST_HEAD(early_platfo
>  static __initdata LIST_HEAD(early_platform_device_list);
>  
>  /**
> - * early_platform_driver_register
> + * early_platform_driver_register - register early platform driver
>   * @epdrv: early_platform driver structure
>   * @buf: string passed from early_param()
> + *
> + * Helper function for early_platform_init() / early_platform_init_buffer()
>   */
>  int __init early_platform_driver_register(struct early_platform_driver *epdrv,
>  					  char *buf)
> @@ -1106,9 +1108,12 @@ int __init early_platform_driver_registe
>  }
>  
>  /**
> - * early_platform_add_devices - add a numbers of early platform devices
> + * early_platform_add_devices - adds a number of early platform devices
>   * @devs: array of early platform devices to add
>   * @num: number of early platform devices in array
> + *
> + * Used by early architecture code to register early platform devices and
> + * their platform data.
>   */
>  void __init early_platform_add_devices(struct platform_device **devs, int num)
>  {
> @@ -1128,8 +1133,12 @@ void __init early_platform_add_devices(s
>  }
>  
>  /**
> - * early_platform_driver_register_all
> + * early_platform_driver_register_all - register early platform drivers
>   * @class_str: string to identify early platform driver class
> + *
> + * Used by architecture code to register all early platform drivers
> + * for a certain class. If omitted then only early platform drivers
> + * with matching kernel command line class parameters will be registered.
>   */
>  void __init early_platform_driver_register_all(char *class_str)
>  {
> @@ -1151,7 +1160,7 @@ void __init early_platform_driver_regist
>  }
>  
>  /**
> - * early_platform_match
> + * early_platform_match - find early platform device matching driver
>   * @epdrv: early platform driver structure
>   * @id: id to match against
>   */
> @@ -1169,7 +1178,7 @@ early_platform_match(struct early_platfo
>  }
>  
>  /**
> - * early_platform_left
> + * early_platform_left - check if early platform driver has matching devices
>   * @epdrv: early platform driver structure
>   * @id: return true if id or above exists
>   */
> @@ -1187,7 +1196,7 @@ static  __init int early_platform_left(s
>  }
>  
>  /**
> - * early_platform_driver_probe_id
> + * early_platform_driver_probe_id - probe drivers matching class_str and id
>   * @class_str: string to identify early platform driver class
>   * @id: id to match against
>   * @nr_probe: number of platform devices to successfully probe before exiting
> @@ -1257,10 +1266,14 @@ static int __init early_platform_driver_
>  }
>  
>  /**
> - * early_platform_driver_probe
> + * early_platform_driver_probe - probe a class of registered drivers
>   * @class_str: string to identify early platform driver class
>   * @nr_probe: number of platform devices to successfully probe before exiting
>   * @user_only: only probe user specified early platform devices
> + *
> + * Used by architecture code to probe registered early platform drivers
> + * within a certain class. For probe to happen a registered early platform
> + * device matching a registered early platform driver is needed.
>   */
>  int __init early_platform_driver_probe(char *class_str,
>  				       int nr_probe,


-- 
~Randy
