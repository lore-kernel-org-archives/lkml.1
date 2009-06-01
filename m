Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbZFALBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbZFALBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZFALBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:01:37 -0400
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:59296 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753370AbZFALBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:01:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CtS6Pw965+miBZmTG5ELGHnXVK7i42gVPLw62y3PcccPHiCHUTpucbjD3w+mZOHa5+LQva9O2F1VrtmY1BYU0F3tXal9PYzg+kI0M+aqXNWTgKgNTz5v6psey9jSMoF+;
Date: Mon, 1 Jun 2009 12:01:26 +0100
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jarod Wilson <jarod@redhat.com>
Cc: dri-devel@lists.sourceforge.net, xorg-devel@lists.x.org,
       linux-kernel@vger.kernel.org, Florian Demmer <florian@demmer.org>,
       eric@anholt.net
Subject: Re: [PATCH] drm: intel: add ignore lvds quirk info for AOpen Mini
 PC
Message-ID: <20090601120126.550b2d15@jbarnes-x200>
In-Reply-To: <200905271720.40776.jarod@redhat.com>
References: <200905271720.40776.jarod@redhat.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 158.43.2.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 17:20:39 -0400
Jarod Wilson <jarod@redhat.com> wrote:

> Fix a FIXME in the intel LVDS bring-up code, adding the appropriate
> blacklist entry for the AOpen Mini PC, courtesy of a dmidecode
> dump from Florian Demmer.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> CC: Florian Demmer <florian@demmer.org>
> 
> ---
>  drivers/gpu/drm/i915/intel_lvds.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c
> b/drivers/gpu/drm/i915/intel_lvds.c index 439a865..7ac00c3 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -424,8 +424,14 @@ static const struct dmi_system_id __initdata
> intel_no_lvds[] = { DMI_MATCH(DMI_PRODUCT_NAME, "Studio Hybrid 140g"),
>  		},
>  	},
> -
> -	/* FIXME: add a check for the Aopen Mini PC */
> +	{
> +		.callback = intel_no_lvds_dmi_callback,
> +		.ident = "AOpen Mini PC",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "AOpen"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "i965GMx-IF"),
> +		},
> +	},
>  
>  	{ }	/* terminating entry */
>  };
> 

Looks fine to me, Eric?  Patches to the i915 driver should generally go
to intel-gfx@lists.freedesktop.org so we don't miss them.  Thanks.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
