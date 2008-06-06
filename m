Return-Path: <linux-kernel-owner+w=401wt.eu-S932598AbYFFUu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbYFFUu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYFFUuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:50:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450AbYFFUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:50:20 -0400
Date: Fri, 6 Jun 2008 13:50:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie, keithp@keithp.com
Subject: Re: [intel-agp] Rewrite GTT on resume
Message-Id: <20080606135015.3f42820d.akpm@linux-foundation.org>
In-Reply-To: <1212550880.4677.5.camel@koto.keithp.com>
References: <1212550880.4677.5.camel@koto.keithp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 20:41:20 -0700
Keith Packard <keithp@keithp.com> wrote:

> On my Intel chipset (965GM), the GTT is entirely erased across
> suspend/resume. This patch simply re-plays the current mapping at resume
> time to restore the table. 
> 
> I noticed this once I started relying on persistent GTT mappings across
> VT switch in our GEM work -- the old X server and DRM code carefully
> unbind all memory from the GTT on VT switch, but GEM does not bother.
> 
> I placed the list management and rewrite code in the generic layer on
> the assumption that it will be needed on other hardware, but I did not
> add the rewrite call to anything other than the Intel resume function.
> 
> 
> commit 1233057731935fb5e9fd115d3d2985802ab636c8
> Author: Keith Packard <keithp@keithp.com>
> Date:   Tue Jun 3 20:34:54 2008 -0700
> 
>     [INTEL-AGP] Re-write GATT on resume
>     
>     Keep a list of current GATT mappings. At resume time, rewrite them into the
>     GATT. This is needed on Intel (at least) as the entire GATT is cleared
>     across suspend/resume.

Please send a signed-off-by:?

> diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
> index c69f795..253f56f 100644
> --- a/drivers/char/agp/agp.h
> +++ b/drivers/char/agp/agp.h
> @@ -148,6 +148,8 @@ struct agp_bridge_data {
>  	char minor_version;
>  	struct list_head list;
>  	u32 apbase_config;
> +	/* list of agp_memory mapped to the aperture */
> +	struct list_head mapped_list;
>  };

Is it safe to use this without locking?

