Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYAYQUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYAYQUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYAYQUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:20:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbYAYQUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:20:39 -0500
Date: Fri, 25 Jan 2008 08:20:20 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 136/196] Kobject: convert net/bridge/br_if.c to use
 kobject_init/add_ng()
Message-ID: <20080125082020.238873ae@deepthought>
In-Reply-To: <1201246425-5058-57-git-send-email-gregkh@suse.de>
References: <20080125071127.GA4860@kroah.com>
	<1201246425-5058-57-git-send-email-gregkh@suse.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 23:32:45 -0800
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> This converts the code to use the new kobject functions, cleaning up the
> logic in doing so.
> 
> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  net/bridge/br_if.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index dadec94..298e0f4 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -258,12 +258,6 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
>  	p->state = BR_STATE_DISABLED;
>  	br_stp_port_timer_init(p);
>  
> -	kobject_init(&p->kobj);
> -	kobject_set_name(&p->kobj, SYSFS_BRIDGE_PORT_ATTR);
> -	p->kobj.ktype = &brport_ktype;
> -	p->kobj.parent = &(dev->dev.kobj);
> -	p->kobj.kset = NULL;
> -
>  	return p;
>  }
>  
> @@ -379,7 +373,8 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
>  	if (IS_ERR(p))
>  		return PTR_ERR(p);
>  
> -	err = kobject_add(&p->kobj);
> +	err = kobject_init_and_add(&p->kobj, &brport_ktype, &(dev->dev.kobj),
> +				   SYSFS_BRIDGE_PORT_ATTR);
>  	if (err)
>  		goto err0;
>  
> @@ -416,6 +411,7 @@ err2:
>  	br_fdb_delete_by_port(br, p, 1);
>  err1:
>  	kobject_del(&p->kobj);
> +	return err;
>  err0:
>  	kobject_put(&p->kobj);
>  	return err;

This is fine, no issues.

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
