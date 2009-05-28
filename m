Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbZE1PJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbZE1PJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZE1PJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:09:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbZE1PJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:09:31 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH 2/2 -tip] drm/i915: intel_lvds.c fix section mismatch warning
Date: Thu, 28 May 2009 11:00:20 -0400
User-Agent: KMail/1.11.3 (Linux/2.6.29.3-140.fc11.x86_64; KDE/4.2.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Eric Anholt <eric@anholt.net>, mjg@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1242800768.3260.21.camel@localhost.localdomain> <1242800855.3260.23.camel@localhost.localdomain>
In-Reply-To: <1242800855.3260.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905281100.21386.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 May 2009 02:27:35 Jaswinder Singh Rajput wrote:
> 
> intel_no_lvds[] does not require __initdata as it is used only by :
> 
>   void intel_lvds_init(struct drm_device *dev)
> 
> fixes section mismatch warning:
> 
>   WARNING: drivers/gpu/drm/i915/i915.o(.text+0xf3c5): Section mismatch in reference from the function intel_lvds_init() to the variable .init.data:intel_no_lvds
>   The function intel_lvds_init() references
>   the variable __initdata intel_no_lvds.
>   This is often because intel_lvds_init lacks a __initdata

This would seem to suggest __initdata should be added to
intel_lvds_init, rather than removed from intel_no_lvds...

But I suppose either one would work. Apologies for not
catching the initial mismatch... :\

> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  drivers/gpu/drm/i915/intel_lvds.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> index 439a865..5ffadf9 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -391,7 +391,7 @@ static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
>  }
>  
>  /* These systems claim to have LVDS, but really don't */
> -static const struct dmi_system_id __initdata intel_no_lvds[] = {
> +static const struct dmi_system_id intel_no_lvds[] = {
>  	{
>  		.callback = intel_no_lvds_dmi_callback,
>  		.ident = "Apple Mac Mini (Core series)",


-- 
Jarod Wilson
jarod@redhat.com
