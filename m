Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXLLTtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXLLTtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXLLTtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:49:46 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:2472 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752228AbXLLTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:49:46 -0500
Date: Wed, 12 Dec 2007 22:52:49 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       akpm@linux-foundation.org, cbou@mail.ru
Subject: Re: [PATCH 2/2] power: fix incorrect unregistration in power_supply_create_attrs error path
Message-ID: <20071212195249.GB16241@localhost.localdomain>
Reply-To: avorontsov@ru.mvista.com
References: <20071212141259.67b4e1d9@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20071212141259.67b4e1d9@ephemeral>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 02:12:59PM -0500, Andres Salomon wrote:
> 
> In power_supply_create_attrs(), we create static attributes as referenced
> by power_supply_static_attrs[i].  After that, if we fail, we unregister
> via power_supply_static_attrs[psy->properties[i]].  This is incorrect, as
> psy->properties has absolutely no bearing on static attribs.  This patch
> fixes it to unregister the correct attrib.
> 
> Another line which was unnecessarily line wrapped is also unwrapped.

Will apply to battery-2.6.git, and will try to push this into 2.6.24.

Much thanks.

> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  drivers/power/power_supply_sysfs.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 0331e82..8efedba 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -153,8 +153,7 @@ dynamics_failed:
>  			   &power_supply_attrs[psy->properties[j]]);
>  statics_failed:
>  	while (i--)
> -		device_remove_file(psy->dev,
> -			   &power_supply_static_attrs[psy->properties[i]]);
> +		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
>  succeed:
>  	return rc;
>  }
> @@ -164,8 +163,7 @@ void power_supply_remove_attrs(struct power_supply *psy)
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++)
> -		device_remove_file(psy->dev,
> -			    &power_supply_static_attrs[i]);
> +		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
>  
>  	for (i = 0; i < psy->num_properties; i++)
>  		device_remove_file(psy->dev,
> -- 
> 1.5.3.5
> 
> 

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
