Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYAAK0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYAAK0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYAAK0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:26:37 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34626 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbYAAK0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:26:36 -0500
Date: Tue, 1 Jan 2008 11:26:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>, mshefty@ichips.intel.com,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, hal.rosenstock@gmail.com
Subject: Re: [Patch 5/8] INFINIBAND: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101102637.GE28913@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101073331.GF2496@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101073331.GF2496@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:33:31PM +0800, WANG Cong wrote:
> 
> TOPDIR is obsolete, use objtree instead.
> This patch removes TOPDIR from all infiniband Makefiles.
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Roland Dreier <rolandd@cisco.com>
> Cc: Sean Hefty <mshefty@ichips.intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> diff --git a/drivers/infiniband/hw/cxgb3/Makefile b/drivers/infiniband/hw/cxgb3/Makefile
> index 36b9898..b82286a 100644
> --- a/drivers/infiniband/hw/cxgb3/Makefile
> +++ b/drivers/infiniband/hw/cxgb3/Makefile
> @@ -1,5 +1,5 @@
> -EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3 \
> -		-I$(TOPDIR)/drivers/infiniband/hw/cxgb3/core

> +EXTRA_CFLAGS += -I$(objtree)/drivers/net/cxgb3 \
Drop $(TOPDIR) like this:
> +EXTRA_CFLAGS += -Idrivers/net/cxgb3 \

> +		-I$(objtree)/drivers/infiniband/hw/cxgb3/core
And this line can be deleted - there is no such directory.
At least not in my tree.

	Sam
