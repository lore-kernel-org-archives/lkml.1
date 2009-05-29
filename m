Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZE2GS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZE2GS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZE2GSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:18:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:38847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZE2GSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:18:20 -0400
Subject: Re: [PATCH 2/2 -tip] drm/i915: intel_lvds.c fix section mismatch
 warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jarod Wilson <jarod@redhat.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, drm list <dri-devel@lists.sf.net>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Anholt <eric@anholt.net>, mjg@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200905281100.21386.jarod@redhat.com>
References: <1242800768.3260.21.camel@localhost.localdomain>
	 <1242800855.3260.23.camel@localhost.localdomain>
	 <200905281100.21386.jarod@redhat.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 11:46:35 +0530
Message-Id: <1243577795.3159.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 11:00 -0400, Jarod Wilson wrote:
> On Wednesday 20 May 2009 02:27:35 Jaswinder Singh Rajput wrote:
> > 
> > intel_no_lvds[] does not require __initdata as it is used only by :
> > 
> >   void intel_lvds_init(struct drm_device *dev)
> > 
> > fixes section mismatch warning:
> > 
> >   WARNING: drivers/gpu/drm/i915/i915.o(.text+0xf3c5): Section mismatch in reference from the function intel_lvds_init() to the variable .init.data:intel_no_lvds
> >   The function intel_lvds_init() references
> >   the variable __initdata intel_no_lvds.
> >   This is often because intel_lvds_init lacks a __initdata
> 
> This would seem to suggest __initdata should be added to
> intel_lvds_init, rather than removed from intel_no_lvds...
> 

The complete statement is :

WARNING: drivers/gpu/drm/i915/i915.o(.text+0xf3c5): Section mismatch in reference from the function intel_lvds_init() to the variable .init.data:intel_no_lvds
The function intel_lvds_init() references
the variable __initdata intel_no_lvds.
This is often because intel_lvds_init lacks a __initdata 
annotation or the annotation of intel_no_lvds is wrong.

> But I suppose either one would work. Apologies for not
> catching the initial mismatch... :\
> 

No another way it will not work.

As intel_no_lvds is used by intel_lvds_init and dmi_check_system.

We can not set intel_lvds_init as intel_lvds_init is used by :
  static void intel_setup_outputs(struct drm_device *dev)

We can not set dmi_check_system to __init as it is also exported.

So the only option is to remove __initdata.

It seems the first patch : "[PATCH 1/2 -tip] drm/i915: acpi/video.c fix
section mismatch warning" is applied in acpi tree by Len Brown.

I am not sure where this patch should go.

So I am also mailing to Andrew and Dave, it they find this useful then
they can add in their tree.

> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  drivers/gpu/drm/i915/intel_lvds.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> > index 439a865..5ffadf9 100644
> > --- a/drivers/gpu/drm/i915/intel_lvds.c
> > +++ b/drivers/gpu/drm/i915/intel_lvds.c
> > @@ -391,7 +391,7 @@ static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
> >  }
> >  
> >  /* These systems claim to have LVDS, but really don't */
> > -static const struct dmi_system_id __initdata intel_no_lvds[] = {
> > +static const struct dmi_system_id intel_no_lvds[] = {
> >  	{
> >  		.callback = intel_no_lvds_dmi_callback,
> >  		.ident = "Apple Mac Mini (Core series)",
> 
> 

