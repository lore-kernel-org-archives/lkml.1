Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbYBKVrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbYBKVrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYBKVrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:47:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52318 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318AbYBKVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:47:22 -0500
Date: Mon, 11 Feb 2008 13:38:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas, Sujith" <sujith.thomas@intel.com>
Cc: lenb@kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rui.zhang@intel.com
Subject: Re: [Bug-fix]:2.6.25-rc0 Generic thermal management [Patch 1/2]:
 validating input parameters
Message-Id: <20080211133827.16140ba0.akpm@linux-foundation.org>
In-Reply-To: <05B550FD4BD2014E841D83547B62600802A3A1B0@bgsmsx411.gar.corp.intel.com>
References: <05B550FD4BD2014E841D83547B62600802A3A1B0@bgsmsx411.gar.corp.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 15:57:06 +0530
"Thomas, Sujith" <sujith.thomas@intel.com> wrote:

> From: Thomas Sujith <sujith.thomas@intel.com>
> 
> Added sanity checks for interface functions in thermal with
> other modules such as fan, processor, video etc..
> 
> Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
> ---
> drivers/thermal/thermal.c |   69
> +++++++++++++++++++++++++++++-----------------

The patch is fairly seriously wordwrapped.

>  1 files changed, 44 insertions(+), 25 deletions(-)
> 
> Index: linux-2.6.24-rc3/drivers/thermal/thermal.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/drivers/thermal/thermal.c
> +++ linux-2.6.24-rc3/drivers/thermal/thermal.c
> @@ -301,13 +301,27 @@ int thermal_zone_bind_cooling_device(str
>  {
>  	struct thermal_cooling_device_instance *dev;
>  	struct thermal_cooling_device_instance *pos;
> +	struct thermal_zone_device *pos1;
> +	struct thermal_cooling_device *pos2;
>  	int result;
>  
> +	if (!tz || !cdev)
> +		return -EINVAL;

Is this change actually needed?  It's sloppy for a caller to be passing
invalid arguments into a callee, and it's not good for the callee to just
hide that sloppiness.

> -		return NULL;
> +		return  ERR_PTR(-EINVAL);

the patch adds several spaces like this in places where we don't normally
put them.


