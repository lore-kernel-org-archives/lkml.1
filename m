Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208Ab0ANXId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0ANXId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476Ab0ANXIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:08:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695Ab0ANXIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:08:31 -0500
Date: Thu, 14 Jan 2010 15:06:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, InKi Dae <inki.dae@samsung.com>,
       Kyungmin Park <kmpark@infradead.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2.6.33] s3c-fb: Fix divide by zero and broken output
Message-Id: <20100114150658.643294f1.akpm@linux-foundation.org>
In-Reply-To: <1263464783-14434-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20100114102027.GC437@rakim.wolfsonmicro.main>
	<1263464783-14434-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 10:26:23 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> Commit 600ce1a0faafeed1ce6bcfd421bc040b941cbbc1.  ("fix clock setting
> for Samsung SoC Framebuffer") introduced a mandatory refresh parameter
> to the platform data for the S3C framebuffer but did not introduce any
> validation code, causing existing platforms (none of which have refresh
> set) to divide by zero whenever the framebuffer is configured,
> generating warnings and unusable output.
> 
> Ben Dooks noted several problems with the patch:
> 
>  - The platform data supplies the pixclk directly and should already
>    have taken care of the refresh rate.
>  - The addition of a window ID parameter doesn't help since only the
>    root framebuffer can control the pixclk.
>  - pixclk is specified in picoseconds (rather than Hz) as the patch
>    assumed.
> 
> and suggests reverting the commit so do that.  Without fixing this no
> mainline user of the driver will produce output.
> 

Why on earth would you revert someone's patch and not tell them that
you're doing it?

This reversion will presumably break the Samsung SoC Framebuffer again.
How about we not do that?

> @@ -358,6 +359,8 @@ static int s3c_fb_set_par(struct fb_info *info)
>  
>  	data = var->xres * var->yres;
>  
> +	u32 osdc_data = 0;
> +
>  	osdc_data = VIDISD14C_ALPHA1_R(0xf) |
>  		VIDISD14C_ALPHA1_G(0xf) |
>  		VIDISD14C_ALPHA1_B(0xf);

The reversion restores this incorrect c99-style declaration.
