Return-Path: <linux-kernel-owner+w=401wt.eu-S1423213AbXBBUgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423213AbXBBUgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 15:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423214AbXBBUgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 15:36:12 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3303 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423213AbXBBUgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 15:36:11 -0500
Date: Fri, 2 Feb 2007 15:20:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: proski@gnu.org, hermes@gibson.dropbear.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix unaligned exception in /drivers/net/wireless/orinoco.c
Message-ID: <20070202202039.GA9382@tuxdriver.com>
References: <600D5CB4DFD93545BF61FF01473D11AC0783715B@limkexm2.ad.analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC0783715B@limkexm2.ad.analog.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 18, 2007 at 09:57:18AM -0000, Hennerich, Michael wrote:
> 
> This short patch prevents an unaligned exception to occur. (GCC 4.1)
> tmp is defined as char pointer while it is later accessed as short.
> 
> Best regards,
> Michael 
> 
> Index: linux-2.6.19.2/drivers/net/wireless/orinoco.c
> ===================================================================
> --- linux-2.6.x/drivers/net/wireless/orinoco.c  (Revision 2649)
> +++ linux-2.6.x/drivers/net/wireless/orinoco.c  (Arbeitskopie)
> @@ -2053,7 +2053,7 @@
>         int err;
>         struct comp_id nic_id, sta_id;
>         unsigned int firmver;
> -       char tmp[SYMBOL_MAX_VER_LEN+1];
> +       char tmp[SYMBOL_MAX_VER_LEN+1] __attribute__ ((aligned(2)));
> 
>         /* Get the hardware version */
>         err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_NICID, &nic_id);

This patch seems fine, such as it is.  But, it seems like it might
also be appropriate to change hermes_read_ltv and/or hermes_read_words
to not take void * parameters?  This patch would still be needed,
but it might be more obvious to future coders?

John
-- 
John W. Linville
linville@tuxdriver.com
