Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYE1TFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYE1TFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYE1TFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:05:42 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2398 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYE1TFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:05:41 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2008 15:05:41 EDT
Date: Wed, 28 May 2008 18:56:11 +0000
From: thunder7@xs4all.nl
To: Jan Engelhardt <jengelh@medozas.de>
Cc: thunder7@xs4all.nl, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: vt/fbcon: fix background color on line feed
Message-ID: <20080528185611.GA25696@wl500g>
References: <alpine.LNX.1.10.0805101015110.19952@fbirervta.pbzchgretzou.qr> <20080527193304.GA21560@amd64.of.nowhere> <alpine.LNX.1.10.0805281003040.12937@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805281003040.12937@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Wed, May 28, 2008 at 07:08:30PM +0200

> commit 7f676fb7cf34dd2982d0cf79aeea7e5b06ad91eb
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed May 28 10:00:41 2008 +0200
> 
>     vt: fix background color on line feed, DEC invert
>     
>     Original report: """I used to force my console to black-on-white by
>     the command `setterm -inversescreen on`. In 2.6.26-rc4, I get lots of
>     black background characters."""
>     
>     Another addendum to commit c9e587ab.
>     This was previously missed out since I was not aware of what
>     vc_decscnm was for.
>     
>     Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  drivers/char/vt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index fa1ffbf..b8b2498 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -434,7 +434,7 @@ static void update_attr(struct vc_data *vc)
>  	              vc->vc_blink, vc->vc_underline,
>  	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
>  	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
> -	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, false, false) << 8) | ' ';
> +	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, vc->vc_decscnm, false) << 8) | ' ';
>  }
>  
>  /* Note: inverting the screen twice should revert to the original state */
> 

Thanks, that fixes my issue with setterm -inversescreen on in
2.6.26-rc4.

Kind regards,
Jurriaan
-- 
"Light makes shadows. We all cast them. We'd be foolish to believe other-
wise. But that one--" She tilted her chin over her shoulder. "She darkens
those near her. She was a shadow before the sun ever touched her."
	Melanie Rawn - Skybowl
