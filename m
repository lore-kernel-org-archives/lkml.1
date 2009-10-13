Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbZJMT0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbZJMT0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761096AbZJMT0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:26:14 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:50521 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761079AbZJMT0O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:26:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BIcPyETpaGECDmCWpLmAmWVYq8gfOimEiDMg9BNFFHwe2/HGesAlXd8T+aUDWCIO5jvz1zR/K0iUW6mPPwzYtCMpowltTsxRNmDgf4pPtIzqRdTUdXNPo+salTca+SSf;
Date: Tue, 13 Oct 2009 12:25:15 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Keith Packard <keithp@keithp.com>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
  laptops
Message-ID: <20091013122515.5074d7f3@jbarnes-g45>
In-Reply-To: <b637ec0b0910131219u638e37dan2f3a98a9a89a2570@mail.gmail.com>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
	<20091008103620.5e5aae66@jbarnes-g45>
	<20091010204106.GA8251@mit.edu>
	<20091012095438.1e82b54f@jbarnes-g45>
	<20091012184651.GA4603@Pilar.aei.mpg.de>
	<20091012120510.16bd1194@jbarnes-g45>
	<b637ec0b0910131219u638e37dan2f3a98a9a89a2570@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below should have only affected GM45 chipsets, what chipset
do you have (lspci -vvv -s 02.0 should tell you).

Sounds like this patch was good enough for both you and Carlos, but not
sufficient for Ted or Keith.  What resolution are you running?

Jesse

On Tue, 13 Oct 2009 21:19:32 +0200
Fabio Comolli <fabio.comolli@gmail.com> wrote:

> Hi Jesse.
> Sorry to jump in but I also had issues with -32rc (i915 chip) and this
> patch seems to have resolved all problems.
> 
> I don't know how to describe in english what happened to my desktop
> but probably "glitches" and "tearings" could be the correct words.
> Also sometimes the screen went blank and needed to switch to terminal
> console and back to return to the normal X screen.
> 
> Nothing in the logs, neither messages nor Xorg.0.log.
> 
> Regards,
> Fabio
> 
> 
> 
> On Mon, Oct 12, 2009 at 9:05 PM, Jesse Barnes
> <jbarnes@virtuousgeek.org> wrote:
> > On Mon, 12 Oct 2009 20:46:51 +0200
> > "Carlos R. Mafra" <crmafra2@gmail.com> wrote:
> >
> >> On Mon 12.Oct'09 at  9:54:38 -0700, Jesse Barnes wrote:
> >> > >
> >> > > Nope, unfortunately, it's not helping on my T400 laptop.  I'm
> >> > > still getting huge amounts of glitching and tearing with this
> >> > > patch applied against -rc3.
> >> > >
> >> > > What I'm using for now to fix up my system is this patch.
> >> > >
> >> >
> >> > How about this one?  I have one more idea to try out if this
> >> > doesn't work (hacking on it now).
> >>
> >> I was also experiencing something very similar to Theodore's bug
> >> report and, at least for me, the patch below fixed the issue (the
> >> previous one also had no effect).
> >
> > Cool, good to hear.  Hopefully Ted and Keith will confirm too.
> >
> > --
> > Jesse Barnes, Intel Open Source Technology Center
> >
> > diff --git a/drivers/gpu/drm/i915/intel_display.c
> > b/drivers/gpu/drm/i915/intel_display.c index 7a5fb79..1451945 100644
> > --- a/drivers/gpu/drm/i915/intel_display.c
> > +++ b/drivers/gpu/drm/i915/intel_display.c
> > @@ -1047,7 +1047,7 @@ static void g4x_enable_fbc(struct drm_crtc
> > *crtc, unsigned long interval) dev_priv->cfb_fence =
> > obj_priv->fence_reg; dev_priv->cfb_plane = intel_crtc->plane;
> >
> > -       dpfc_ctl = plane | DPFC_SR_EN | DPFC_CTL_LIMIT_1X;
> > +       dpfc_ctl = plane | DPFC_CTL_LIMIT_1X;
> >        if (obj_priv->tiling_mode != I915_TILING_NONE) {
> >                dpfc_ctl |= DPFC_CTL_FENCE_EN | dev_priv->cfb_fence;
> >                I915_WRITE(DPFC_CHICKEN, DPFC_HT_MODIFY);
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
