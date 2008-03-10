Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbYCJUR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbYCJUR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYCJUOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:14:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756045AbYCJUOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:14:48 -0400
Date: Mon, 10 Mar 2008 13:14:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: Re: [PATCH 3/6] gxfb: move MSR bit fields into gxfb.h
Message-Id: <20080310131432.e4567537.akpm@linux-foundation.org>
In-Reply-To: <20080308204840.47a27236@ephemeral>
References: <20080308204840.47a27236@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008 20:48:40 -0500
Andres Salomon <dilinger@queued.net> wrote:

> >From bee7242cf04c4a060b311b11985efb495f308355 Mon Sep 17 00:00:00 2001
> From: Andres Salomon <dilinger@debian.org>
> Date: Mon, 25 Feb 2008 15:29:36 -0500
> Subject: [PATCH] gxfb: move MSR bit fields into gxfb.h
> 
> This continues the gxfb header cleanups.  MSRs are defined in geode.h;
> the specific bits we care about are defined in gxfb.h.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  drivers/video/geode/display_gx.h |    3 ---
>  drivers/video/geode/gxfb.h       |   16 ++++++++++++++++
>  drivers/video/geode/gxfb_core.c  |    2 +-
>  drivers/video/geode/video_gx.c   |    4 ++--
>  drivers/video/geode/video_gx.h   |   14 --------------
>  5 files changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/video/geode/display_gx.h b/drivers/video/geode/display_gx.h
> index 56e9d2e..ad556d3 100644
> --- a/drivers/video/geode/display_gx.h
> +++ b/drivers/video/geode/display_gx.h
> @@ -16,7 +16,4 @@ int gx_line_delta(int xres, int bpp);
>  
>  extern struct geode_dc_ops gx_dc_ops;
>  
> -/* MSR that tells us if a TFT or CRT is attached */
> -#define GLD_MSR_CONFIG_DM_FP 0x40
> -
>  #endif /* !__DISPLAY_GX1_H__ */

Something has gone wrong here.  The code in current mainline is



extern struct geode_dc_ops gx_dc_ops;

/* MSR that tells us if a TFT or CRT is attached */
#define GLD_MSR_CONFIG   0xC0002001
#define GLD_MSR_CONFIG_DM_FP 0x40

/* Display controller registers */


whereas you're patching something else.


In [1/6] you refer to "the MSR cleanup patch".  I don't know what that is.


Please clean up the changelogs - remove those email headers from the
email-forwarding operation and remove the additional little commentary on
top: if there's actually anything in there which is needed then it should
be integrated into the changelog proper, thanks.

