Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbXIEPVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbXIEPVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXIEPVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:21:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25074 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbXIEPVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:21:41 -0400
Date: Wed, 5 Sep 2007 08:19:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33
Message-Id: <20070905081937.35965e97.randy.dunlap@oracle.com>
In-Reply-To: <20070905071152.GA5817@zhen-devel.sh.intel.com>
References: <20070905071152.GA5817@zhen-devel.sh.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007 15:11:52 +0800 Zhenyu Wang wrote:

>  drivers/char/agp/intel-agp.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index 2c9ca2c..20d50d0 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -506,6 +506,11 @@ static void intel_i830_init_gtt_entries(void)
>  			break;
>  		}
>  	} else {
> +		/* G33's GTT stolen memory is seperate from gfx data

                                              separate

> +		 * stolen memory.
> +		 */
> +	        if (IS_G33)
> +		    size = 0;
>  		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
>  		case I855_GMCH_GMS_STOLEN_1M:
>  			gtt_entries = MB(1) - KB(size);

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
