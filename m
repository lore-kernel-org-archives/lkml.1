Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYEGCGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYEGCGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYEGCGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:06:39 -0400
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:59460 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYEGCGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:06:38 -0400
X-Greylist: delayed 2841 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 22:06:38 EDT
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18FlU2aWvlhM/QBwJi9zToY
Date: Tue, 6 May 2008 18:19:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       paul@pwsan.com
Subject: Re: vanilla kernel is broken on omap board
Message-ID: <20080507011914.GM18682@atomide.com>
References: <9c9fda240805061748n3287cb24v530f779b6b622d53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c9fda240805061748n3287cb24v530f779b6b622d53@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Kyungmin Park <kmpark@infradead.org> [080506 17:48]:
> Hi Tony,
> 
> Current vanilla kernel is broken on omap2 boards.
> In the previous time you committed some omap2 patches, but some
> patches are not missing.
> Such as Runtime constants series. [1]
> 
> Now "some parts" are already included.
> So you just commit the remain parts too such as in [2]
> In most cases the board files don't set the their own global variables.

Well at least we're getting closer to making omap2 really usable with
mainline kernel :)

Thanks for fixing that, will add this to omap-fixes queue and send it
upstream with bunch of other fixes.

Regards,

Tony


> Thank you,
> Kyungmin Park
> 
> 1. Runtime constants: introduce omap2_set_globals_*()
> http://source.mvista.com/git/gitweb.cgi?p=linux-omap-2.6.git;a=commit;h=2b256e28e8e70592f0c38a862cc4ba0498c9db7b
> Runtime constants: use runtime-computed SDRC base
> http://source.mvista.com/git/gitweb.cgi?p=linux-omap-2.6.git;a=commitdiff;h=7b5f8cdb222052a7aa02ed38c59e0af1946b1e06
> Runtime constants: use runtime-computed SMS base
> http://source.mvista.com/git/gitweb.cgi?p=linux-omap-2.6.git;a=commitdiff;h=80ccf4b99eb3892809bbebf7673bdd1a359d56ff
> 
> 2.
> diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apo
> index a1e1e67..620fa0f 100644
> --- a/arch/arm/mach-omap2/board-apollon.c
> +++ b/arch/arm/mach-omap2/board-apollon.c
> @@ -394,6 +394,7 @@ static void __init omap_apollon_init(void)
> 
>  static void __init omap_apollon_map_io(void)
>  {
> +       omap2_set_globals_242x();
>         omap2_map_common_io();
>  }
> diff --git a/include/asm-arm/arch-omap/common.h b/include/asm-arm/arch-omap/comm
> index 224e009..36a3b62 100644
> --- a/include/asm-arm/arch-omap/common.h
> +++ b/include/asm-arm/arch-omap/common.h
> @@ -47,4 +47,8 @@ static inline int omap_register_i2c_bus(int bus_id, u32 clkrat
>  }
>  #endif
> 
> +void omap2_set_globals_242x(void);
> +void omap2_set_globals_243x(void);
> +void omap2_set_globals_343x(void);
> +
>  #endif /* __ARCH_ARM_MACH_OMAP_COMMON_H */
