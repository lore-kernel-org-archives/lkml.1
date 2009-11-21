Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZKVOSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZKVOSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 09:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbZKVOSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 09:18:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56773 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZKVOSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 09:18:47 -0500
Date: Sun, 22 Nov 2009 00:46:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.32-rc7: compile regression on spitz
Message-ID: <20091121234611.GG1411@ucw.cz>
References: <20091118090100.GA1399@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118090100.GA1399@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-18 10:01:00, Pavel Machek wrote:
> 
> If CONFIG_AKITA is not set, spitz fails to compile. It worked ok in
> rc5. Fix is one more ifdef...
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Eric, this being after-rc5 regression... it would be nice to actually
fix it for final...
								Pavel

> --- a/arch/arm/mach-pxa/spitz.c	2009-11-17 17:10:21.000000000 +0100
> +++ b/arch/arm/mach-pxa/spitz.c	2009-11-18 05:55:21.000000000 +0100
> @@ -802,10 +802,12 @@
>  {
>  	spitz_ficp_platform_data.gpio_pwdown = SPITZ_GPIO_IR_ON;
>  
> +#ifdef CONFIG_MACH_BORZOI
>  	if (machine_is_borzoi()) {
>  		sharpsl_nand_platform_data.badblock_pattern = &sharpsl_akita_bbt;
>  		sharpsl_nand_platform_data.ecc_layout = &akita_oobinfo;
>  	}
> +#endif
>  
>  	platform_scoop_config = &spitz_pcmcia_config;
>  
> 
> 
> 
> 
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
