Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbZKJU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbZKJU7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbZKJU7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:59:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33091 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980AbZKJU7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:59:19 -0500
Date: Tue, 10 Nov 2009 20:59:22 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jerome Glisse <jglisse@redhat.com>
cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH] drm/radeon/kms: disable load detection on TV output
In-Reply-To: <1257880483-21478-1-git-send-email-jglisse@redhat.com>
Message-ID: <alpine.DEB.2.00.0911102057460.19146@skynet.skynet.ie>
References: <1257880483-21478-1-git-send-email-jglisse@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Do like in the DDX don't try to load detect TV output, there is a lot
> of false positive detection with those code. Seems to be isolated to
> RS480/RC410 chipset thought. Need more investigations.
> 

NAK, I've not seen any false positive bug reports other than rs480, and
I suspect that is some timing difference due to different ref clock, I've 
tested this code on my r100/r200/r300 cards and seemed to always work 
fine.

So just turn it off for rs480, I'm also seeing a lot of rs480 reporting tv
connectors that don't exist, has the person got a real connector?

Dave.

 > Signed-off-by: Jerome Glisse 
<jglisse@redhat.com>
> ---
>  drivers/gpu/drm/radeon/radeon_connectors.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
> index fce4c40..292b170 100644
> --- a/drivers/gpu/drm/radeon/radeon_connectors.c
> +++ b/drivers/gpu/drm/radeon/radeon_connectors.c
> @@ -1015,7 +1015,7 @@ radeon_add_atom_connector(struct drm_device *dev,
>  			ret = drm_connector_helper_add(&radeon_connector->base, &radeon_tv_connector_helper_funcs);
>  			if (ret)
>  				goto failed;
> -			radeon_connector->dac_load_detect = true;
> +			radeon_connector->dac_load_detect = false;
>  			drm_connector_attach_property(&radeon_connector->base,
>  						      rdev->mode_info.load_detect_property,
>  						      1);
> @@ -1148,7 +1148,7 @@ radeon_add_legacy_connector(struct drm_device *dev,
>  			ret = drm_connector_helper_add(&radeon_connector->base, &radeon_tv_connector_helper_funcs);
>  			if (ret)
>  				goto failed;
> -			radeon_connector->dac_load_detect = true;
> +			radeon_connector->dac_load_detect = false;
>  			drm_connector_attach_property(&radeon_connector->base,
>  						      rdev->mode_info.load_detect_property,
>  						      1);
> 
