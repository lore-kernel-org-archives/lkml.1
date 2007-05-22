Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbXEVWAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbXEVWAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758936AbXEVWAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:00:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50238 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbXEVWAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:00:46 -0400
Date: Tue, 22 May 2007 15:05:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>
Subject: Re: [PATCH 2/2] make fbcon unregister when unloaded
Message-Id: <20070522150504.b797213a.randy.dunlap@oracle.com>
In-Reply-To: <200705221444.52675.jbarnes@virtuousgeek.org>
References: <200705171423.46748.jesse.barnes@intel.com>
	<200705171532.28799.jesse.barnes@intel.com>
	<1179444190.5092.4.camel@daplas>
	<200705221444.52675.jbarnes@virtuousgeek.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 14:44:52 -0700 Jesse Barnes wrote:

> When unloaded, the fbcon driver should unregister itself from the VT
> subsystem using unbind_con_driver.  This patch makes it use the newly
> exported function to do just that.
> 
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> 
> diff -Napur -X /home/jbarnes/dontdiff --exclude=Makefile linux-2.6.22-rc2/drivers/video/console/fbcon.c linux-2.6.22-rc2-modesetting/drivers/video/console/fbcon.c
> --- linux-2.6.22-rc2/drivers/video/console/fbcon.c	2007-05-18 21:06:17.000000000 -0700
> +++ linux-2.6.22-rc2-modesetting/drivers/video/console/fbcon.c	2007-05-22 14:26:20.000000000 -0700
> @@ -2937,6 +2937,21 @@ static int fbcon_mode_deleted(struct fb_
>  	return found;
>  }
>  
> +static int fbcon_fb_unbind(int idx)
> +{
> +	int i;
> +
> +        for (i = 0; i < MAX_NR_CONSOLES; i++) {
> +                /* Assure we do not unbind other drivers */
> +                if (idx == con2fb_map[i])
> +                        /* can be optimize to minimize multiple calls to
> +			   unbind_con_driver() */

			/*
			 * can be optimized to minimize multiple calls
			 * to unbind_con_driver()
			 */

> +                        unbind_con_driver(&fb_con, i, i, 0); 
> +        }
> +
> +	return 0;
> +}

Lots of whitespace mangling there (mostly spaces instead of tabs).

> +
>  static int fbcon_fb_unregistered(int idx)
>  {
>  	int i;

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
