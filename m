Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbXH1Gai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbXH1Gai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbXH1Ga3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:30:29 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3774 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXH1Ga3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:30:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [-mm patch] ivtv-fb.c bugfix
Date: Tue, 28 Aug 2007 08:30:06 +0200
User-Agent: KMail/1.9.7
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       mchehab@infradead.org, linux-kernel@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070827212929.GH26410@stusta.de>
In-Reply-To: <20070827212929.GH26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708280830.06916.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 August 2007 23:29:29 Adrian Bunk wrote:
> On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc2-mm2:
> >...
> >  git-dvb.patch
> >...
> >  git trees
> >...
>
> This patch fixes an obvious bug in ivtvfb_release_buffers().
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Ouch. Thanks.

Mauro, I've added this patch to my v4l-dvb tree. Can you pull from it?

Thanks,

	Hans

>
> ---
> 093bdc9ba94bffbec2ed44743418899771488832
> diff --git a/drivers/media/video/ivtv/ivtv-fb.c
> b/drivers/media/video/ivtv/ivtv-fb.c index 0080765..8a344d5 100644
> --- a/drivers/media/video/ivtv/ivtv-fb.c
> +++ b/drivers/media/video/ivtv/ivtv-fb.c
> @@ -1068,8 +1068,8 @@ static void ivtvfb_release_buffers (struct ivtv
> *itv) struct osd_info *oi = itv->osd_info;
>
>  	/* Release cmap */
> -	if (oi->ivtvfb_info.cmap.len);
> -	fb_dealloc_cmap(&oi->ivtvfb_info.cmap);
> +	if (oi->ivtvfb_info.cmap.len)
> +		fb_dealloc_cmap(&oi->ivtvfb_info.cmap);
>
>  	/* Release pseudo palette */
>  	if (oi->ivtvfb_info.pseudo_palette)
>
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer


