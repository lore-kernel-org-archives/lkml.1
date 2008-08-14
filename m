Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbYHNVGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbYHNVGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYHNVGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:06:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbYHNVGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:06:16 -0400
Date: Thu, 14 Aug 2008 17:05:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080814210512.GA6087@redhat.com>
References: <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080808215153.GA16729@redhat.com> <20080808193851.24210bc4.randy.dunlap@oracle.com> <20080811173616.GC6103@redhat.com> <20080811223309.GD9810@kroah.com> <20080812194817.GD6056@redhat.com> <20080812200908.GA444@kroah.com> <20080812204619.GE6056@redhat.com> <20080814145348.GA25422@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814145348.GA25422@kroah.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 07:53:48AM -0700, Greg KH wrote:
> Also, would it make sense to add a patch like the one below to this
> code?  It might be nice to know when each module's debugging value is
> manually changed by the user for the log files.
> 
> If you like it, I can merge it in the main patch.
> 
> thanks,
> 
> greg k-h
> 
> ---
>  lib/dynamic_printk.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/lib/dynamic_printk.c
> +++ b/lib/dynamic_printk.c
> @@ -288,6 +288,9 @@ static ssize_t pr_debug_write(struct fil
>  					num_enabled++;
>  					dynamic_enabled = DYNAMIC_ENABLED_SOME;
>  					err = 0;
> +					printk(KERN_DEBUG
> +					       "debugging enabled for module %s",
> +					       elem->name);
>  				} else if (!value && (elem->enable == 1)) {
>  					elem->enable = 0;
>  					num_enabled--;
> @@ -304,6 +307,9 @@ static ssize_t pr_debug_write(struct fil
>  						dynamic_enabled =
>  							DYNAMIC_ENABLED_NONE;
>  					err = 0;
> +					printk(KERN_DEBUG
> +					       "debugging disabled for module "
> +					       "%s", elem->name);
>  				}
>  			}
>  		}


looks good. we might also want to add a message for the cases where are the
modules are enabled/disabled too.

thanks,

-Jason
