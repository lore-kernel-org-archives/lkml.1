Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZBFSYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZBFSYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZBFSYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:24:30 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:51607 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZBFSY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:24:29 -0500
Date: Fri, 6 Feb 2009 20:24:15 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] usb: musb: - kill the compile warning
Message-ID: <20090206182415.GB10711@frodo>
Reply-To: me@felipebalbi.com
References: <1233915810-18616-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233915810-18616-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 06:23:30PM +0800, Bryan Wu wrote:
> drivers/usb/musb/musb_core.c:1433: warning: assignment makes pointer
> from integer without a cast
> 	hw_ep->target_regs = musb_read_target_reg_base(i, mbase);
> 
> static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase);
> 
> this is a common bug, but a bug still ?  mbase is a 32/64 bit pointer,
> but we return a u16 to assign to a pointer ?  seems odd :)
> 
> So return right pointer in the stub.
> 
> Cc: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/usb/musb/musb_regs.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
> index de3b2f1..c2f6a16 100644
> --- a/drivers/usb/musb/musb_regs.h
> +++ b/drivers/usb/musb/musb_regs.h
> @@ -333,7 +333,7 @@ static inline u16 musb_read_hwvers(void __iomem *mbase)
>  
>  static inline void __iomem *musb_read_target_reg_base(u8 i, void __iomem *mbase)
>  {
> -	return (MUSB_BUSCTL_OFFSET(i, 0) + mbase);
> +	return (void __iomem *)(MUSB_BUSCTL_OFFSET(i, 0) + mbase);

please don't cast, we don't get this warning in non-blackfin builds
(well, omap at least)

> @@ -473,9 +473,9 @@ static inline u16 musb_read_hwvers(void __iomem *mbase)
>  	return 0;
>  }
>  
> -static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase)
> +static inline void __iomem *musb_read_target_reg_base(u8 i, void __iomem *mbase)
>  {
> -	return 0;
> +	return NULL;

this looks fine

-- 
balbi
