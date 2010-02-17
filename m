Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0BQWGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:06:15 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:44444 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0BQWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:06:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uDuo99orsLWjj53Uu9GNAEJsswD5vngO360fkhugFXihI5lGVCViOv6MeWOXBWjapP
         rcJu/2VPbFTD41oQghwDgIhb7lW6gOwomb9iaLtyvCI5ubwEKQbug9PwBDPXcO7s2Q45
         9ziUa5n2sl1/HunwvWP6pUh1whLEnjtGLgEBA=
Date: Wed, 17 Feb 2010 23:04:01 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
       Ben Skeggs <bskeggs@redhat.com>,
       Francisco Jerez <currojerez@riseup.net>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Chantry <shiningxc@gmail.com>, dri-devel@lists.sourceforge.net,
       nouveau@lists.freedesktop.org
Subject: Re: [PATCH] nouveau: fix undefined reference to acpi_lid_open
Message-ID: <20100217220401.GA3258@joi.lan>
References: <1266399763-28911-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266399763-28911-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 10:42:43AM +0100, Daniel Mack wrote:
> Fix the following compile time error:
> 
> drivers/built-in.o: In function `nouveau_connector_detect':
> /home/daniel/src/linux/jup/linux-2.6/drivers/gpu/drm/nouveau/nouveau_connector.c:243: undefined reference to `acpi_lid_open'
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Francisco Jerez <currojerez@riseup.net>
> Cc: Maarten Maathuis <madman2003@gmail.com>
> Cc: Xavier Chantry <shiningxc@gmail.com>
> Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: dri-devel@lists.sourceforge.net
> ---
>  drivers/gpu/drm/nouveau/nouveau_connector.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
> index d2f6335..c74d45d 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_connector.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
> @@ -239,7 +239,7 @@ nouveau_connector_detect(struct drm_connector *connector)
>  	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
>  		nv_encoder = find_encoder_by_type(connector, OUTPUT_LVDS);
>  	if (nv_encoder && nv_connector->native_mode) {
> -#ifdef CONFIG_ACPI
> +#ifdef CONFIG_ACPI_BUTTON
>  		if (!nouveau_ignorelid && !acpi_lid_open())
>  			return connector_status_disconnected;
>  #endif
> -- 

You are fixing CONFIG_ACPI_BUTTON=m vs CONFIG_DRM_NOUVEAU=y compilation,
but breaking runtime behaviour of CONFIG_ACPI_BUTTON=m + CONFIG_DRM_NOUVEAU=m.

I think this code should be compiled when:
#if defined(CONFIG_ACPI_BUTTON) || (defined(CONFIG_ACPI_BUTTON_MODULE) && defined(CONFIG_DRM_NOUVEAU_MODULE))

Marcin

