Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbZE2Npl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbZE2Npl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbZE2Nnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:43:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40113 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760681AbZE2Nno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:43:44 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH 2/2 -tip] drm/i915: intel_lvds.c fix section mismatch warning
Date: Fri, 29 May 2009 09:34:12 -0400
User-Agent: KMail/1.11.3 (Linux/2.6.29.3-140.fc11.x86_64; KDE/4.2.3; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, drm list <dri-devel@lists.sf.net>,
       Ingo Molnar <mingo@elte.hu>, Eric Anholt <eric@anholt.net>,
       mjg@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <1242800768.3260.21.camel@localhost.localdomain> <200905281100.21386.jarod@redhat.com> <1243577795.3159.27.camel@localhost.localdomain>
In-Reply-To: <1243577795.3159.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905290934.14675.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 May 2009 02:16:35 Jaswinder Singh Rajput wrote:
> On Thu, 2009-05-28 at 11:00 -0400, Jarod Wilson wrote:
> > On Wednesday 20 May 2009 02:27:35 Jaswinder Singh Rajput wrote:
> > > 
> > > intel_no_lvds[] does not require __initdata as it is used only by :
> > > 
> > >   void intel_lvds_init(struct drm_device *dev)
> > > 
> > > fixes section mismatch warning:
> > > 
> > >   WARNING: drivers/gpu/drm/i915/i915.o(.text+0xf3c5): Section mismatch in reference from the function intel_lvds_init() to the variable .init.data:intel_no_lvds
> > >   The function intel_lvds_init() references
> > >   the variable __initdata intel_no_lvds.
> > >   This is often because intel_lvds_init lacks a __initdata
> > 
> > This would seem to suggest __initdata should be added to
> > intel_lvds_init, rather than removed from intel_no_lvds...
> > 
> 
> The complete statement is :
> 
> WARNING: drivers/gpu/drm/i915/i915.o(.text+0xf3c5): Section mismatch in reference from the function intel_lvds_init() to the variable .init.data:intel_no_lvds
> The function intel_lvds_init() references
> the variable __initdata intel_no_lvds.
> This is often because intel_lvds_init lacks a __initdata 
> annotation or the annotation of intel_no_lvds is wrong.

Ah, yeah, I'd have kept my mouth shut if the last line were there the
first time, or at least looked at the code more to understand why you
went this direction. ;)

> I am not sure where this patch should go.
> 
> So I am also mailing to Andrew and Dave, it they find this useful then
> they can add in their tree.

Dave is on vacation a bit longer, iirc. Not entirely sure where else
this might go either. I'm sure *someone* will pick it up sooner or
later... In any case, thanks for the fix for my flub.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com
