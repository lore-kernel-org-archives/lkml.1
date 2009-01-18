Return-Path: <linux-kernel-owner+w=401wt.eu-S934095AbZARP4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095AbZARP4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933683AbZARP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:56:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:38380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933567AbZARP4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:56:22 -0500
Subject: Re: [PATCH 2/3] drivers/gpu/drm: fix sparse warnings: unexport
 symbols
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Hannes Eder <hannes@hanneseder.net>
Cc: dri-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090118152848.4179.85741.stgit@vmbox.hanneseder.net>
References: <20090118152725.4179.40835.stgit@vmbox.hanneseder.net>
	 <20090118152848.4179.85741.stgit@vmbox.hanneseder.net>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 21:26:04 +0530
Message-Id: <1232294164.24415.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 16:28 +0100, Hannes Eder wrote:
> Fix this sparse warnings:
> 
>   drivers/gpu/drm/drm_crtc_helper.c:137:6: warning: symbol 'drm_helper_probe_connector_modes' was not declared. Should it be static?
>   drivers/gpu/drm/drm_modes.c:360:6: warning: symbol 'drm_mode_validate_clocks' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/gpu/drm/drm_crtc_helper.c |    6 +++---
>  drivers/gpu/drm/drm_modes.c       |    7 +++----
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
> index d8a982b..a0b2601 100644
> --- a/drivers/gpu/drm/drm_crtc_helper.c
> +++ b/drivers/gpu/drm/drm_crtc_helper.c
> @@ -134,8 +134,9 @@ void drm_helper_probe_single_connector_modes(struct drm_connector *connector,
>  }
>  EXPORT_SYMBOL(drm_helper_probe_single_connector_modes);
>  
> -void drm_helper_probe_connector_modes(struct drm_device *dev, uint32_t maxX,
> -				      uint32_t maxY)
> +static void drm_helper_probe_connector_modes(struct drm_device *dev,
> +					     uint32_t maxX,
> +					     uint32_t maxY)
>  {
>  	struct drm_connector *connector;
>  
> @@ -143,7 +144,6 @@ void drm_helper_probe_connector_modes(struct drm_device *dev, uint32_t maxX,
>  		drm_helper_probe_single_connector_modes(connector, maxX, maxY);
>  	}
>  }
> -EXPORT_SYMBOL(drm_helper_probe_connector_modes);
>  

hmm, what you are trying to do ?

> 
>  /**
> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
> index 7c36f16..c0cfe39 100644
> --- a/drivers/gpu/drm/drm_modes.c
> +++ b/drivers/gpu/drm/drm_modes.c
> @@ -357,9 +357,9 @@ EXPORT_SYMBOL(drm_mode_validate_size);
>   * sure each mode falls within a given range (defined by @min and @max
>   * arrays) and sets @mode->status as needed.
>   */
> -void drm_mode_validate_clocks(struct drm_device *dev,
> -			      struct list_head *mode_list,
> -			      int *min, int *max, int n_ranges)
> +static void drm_mode_validate_clocks(struct drm_device *dev,
> +				     struct list_head *mode_list,
> +				     int *min, int *max, int n_ranges)
>  {
>  	struct drm_display_mode *mode;
>  	int i;
> @@ -376,7 +376,6 @@ void drm_mode_validate_clocks(struct drm_device *dev,
>  			mode->status = MODE_CLOCK_RANGE;
>  	}
>  }
> -EXPORT_SYMBOL(drm_mode_validate_clocks);

??

--
JSR


