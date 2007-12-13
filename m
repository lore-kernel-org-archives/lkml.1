Return-Path: <linux-kernel-owner+w=401wt.eu-S1765336AbXLMHX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765336AbXLMHX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764218AbXLMHN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:13:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46627 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762172AbXLMHN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:13:28 -0500
Date: Wed, 12 Dec 2007 23:10:22 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: michael@ellerman.id.au, linuxppc-dev@ozlabs.org,
       "Kyle A. Lucke" <klucke@us.ibm.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org, David Gibson <dwg@au1.ibm.com>
Subject: Re: [PATCH] Introduce driver_create/remove_dir
Message-ID: <20071213071022.GB13764@kroah.com>
References: <20071205093054.GA23229@kroah.com> <1196853031.6759.7.camel@concordia> <20071205214103.GA7074@kroah.com> <1196912898.14754.13.camel@concordia> <20071212105633.725496cb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212105633.725496cb.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 10:56:33AM +1100, Stephen Rothwell wrote:
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/base/driver.c      |   24 ++++++++++++++++++++++++
>  drivers/net/iseries_veth.c |   15 +++++++--------
>  include/linux/device.h     |    3 +++
>  3 files changed, 34 insertions(+), 8 deletions(-)
> 
> Greg, does this look like a reasonable solution to iseries_veth accessing
> the "private" kobject in struct device_driver?  This version is against
> maimline, but the stuff you have in mm would just need to update
> driver_create_dir ...

Hm, we just want to be able to get to the kobject somehow here.  Not
create a new api that doesn't match up.  I'll think about it and figure
something that matches the other portions of the api.

> Also something along the lines of device_add_dir() might be good if you
> want to hide the kobject in struct device as well.

As devices _should_ always be dynamic, hopefully I'll not have to do
that.  But knowing some of the platform devices, I'm afraid I'll have to
do that split :)

thanks,

greg k-h
