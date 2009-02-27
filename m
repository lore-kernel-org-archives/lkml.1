Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZB0FxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZB0FxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZB0FxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:53:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:51434 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZB0FxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:53:13 -0500
Date: Fri, 27 Feb 2009 06:55:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Leech <christopher.leech@intel.com>
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net headers: export dcbnl.h
Message-ID: <20090227055506.GA7020@uranus.ravnborg.org>
References: <20090227004635.10247.60814.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227004635.10247.60814.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 04:46:35PM -0800, Chris Leech wrote:
> The DCB netlink interface is required for building the userspace tools
> available at e1000.sourceforge.net

Hmmm, is that file ready for export....

>From dcbnl.h:
#ifndef __LINUX_DCBNL_H__
#define __LINUX_DCBNL_H__

#define DCB_PROTO_VERSION 1

struct dcbmsg {
        unsigned char      dcb_family;
        __u8               cmd;
        __u16              dcb_pad;
};

1) It uses __u8/__u16 so it would be nice it is included <linux/types.h>
so these are actually defined.
2) Why does it use "unsigned char" for one member and __u8 for another.
It looks inconsistent.


We export headers that are much worse but we better raise the bar a little.

	Sam


> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>
> ---
> 
>  include/linux/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index b97cdc5..106c3ba 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -52,6 +52,7 @@ header-y += const.h
>  header-y += cgroupstats.h
>  header-y += cramfs_fs.h
>  header-y += cycx_cfm.h
> +header-y += dcbnl.h
>  header-y += dlmconstants.h
>  header-y += dlm_device.h
>  header-y += dlm_netlink.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
