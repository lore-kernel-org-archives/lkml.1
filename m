Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab0BDS5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:57:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747Ab0BDS5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:57:35 -0500
Date: Thu, 4 Feb 2010 19:56:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204185603.GA6665@elte.hu>
References: <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
 <20100204062619.GA29154@elte.hu>
 <20100204071705.GA28403@elte.hu>
 <20100204164859.GA17878@srcf.ucam.org>
 <20100204170826.GA16397@elte.hu>
 <20100204173602.GA19855@srcf.ucam.org>
 <20100204175445.GB27361@elte.hu>
 <20100204175928.GA20595@srcf.ucam.org>
 <20100204181218.GA6175@elte.hu>
 <20100204181540.GA20922@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204181540.GA20922@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Feb 04, 2010 at 07:12:18PM +0100, Ingo Molnar wrote:
> > 
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > The reason the option was in staging (as has been mentioned before) was 
> > > because the ABI wasn't felt to be stable enough. Upstream is now willing to 
> > > commit to that stability, so now seems as good a time to move it as any. 
> > > There's no code change and there's no default configuration change, so I 
> > > really can't see any way that it can be classed as a regression.
> > 
> > But that argument in essence renders the regression policy meaningless for 
> > such code: just about any new driver feature under the sun could be shaped as 
> > a Kconfig option, introduced via a drivers/staging Kconfig entry, and then 
> > activated via a twoliner commit in a later -rc.
> 
> Before this patch, CONFIG_DRM_RADEON_KMS=y would crash your system on boot. 
> [...]

Hm, in what way does that observation address the concerns i've outlined?

Before this patch i could enable CONFIG_DRM_RADEON_KMS=y only if i enabled 
CONFIG_STAGING, which i dont, because doing so would taint my kernel with 
TAINT_CRAP, and the kernel log would contain:

 "%s: module is from the staging directory, the quality is unknown, you have been warned.",

> [...] After this patch, CONFIG_DRM_RADEON_KMS=y still crashes your system. 
> [...]

After this patch i suddenly get a new body of code with a default-off option 
that would only show up before if i had CONFIG_STAGING=y enabled before.

Do you see my argument why any user who is hit by this would categorize this 
as a kernel regression in an existing driver?

Moving driver functionality from drivers/staging/ to drivers/ might be 
justified, it might be pragmatic, but you dont try to justify it and you dont 
try to outline the pragmatic reasons - from all i can see you seem to argue 
that this is all perfectly fine in late -rc's, which has me worried somewhat.

[ And if that is really fine i'd like to hear Linus's amen on that as well, 
  because i'm sure others would like to use that mechanism too to enable
  new functionality in late -rc's. ]

Thanks,

	Ingo
