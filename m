Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbZJMTUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbZJMTUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZJMTUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:20:11 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:53796 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbZJMTUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kH/kFVlRi5QqueVSpERHiiEneYbIJGqy4isaOG/XqmSscuq8ro8k0+phB3ysn9VClE
         xdmbbDxQ5fAkKikm8+6kJNURjow8m1QYDX3o0MNY+I4XJf8vxc693I6xXk9xHP0B0NX+
         ZguFAQlrJHhLTnp0nkvjXHYNEHXp/xovoMdNc=
MIME-Version: 1.0
In-Reply-To: <20091012120510.16bd1194@jbarnes-g45>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
	 <20091008103620.5e5aae66@jbarnes-g45> <20091010204106.GA8251@mit.edu>
	 <20091012095438.1e82b54f@jbarnes-g45>
	 <20091012184651.GA4603@Pilar.aei.mpg.de>
	 <20091012120510.16bd1194@jbarnes-g45>
Date: Tue, 13 Oct 2009 21:19:32 +0200
Message-ID: <b637ec0b0910131219u638e37dan2f3a98a9a89a2570@mail.gmail.com>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400 
	laptops
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse.
Sorry to jump in but I also had issues with -32rc (i915 chip) and this
patch seems to have resolved all problems.

I don't know how to describe in english what happened to my desktop
but probably "glitches" and "tearings" could be the correct words.
Also sometimes the screen went blank and needed to switch to terminal
console and back to return to the normal X screen.

Nothing in the logs, neither messages nor Xorg.0.log.

Regards,
Fabio



On Mon, Oct 12, 2009 at 9:05 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Mon, 12 Oct 2009 20:46:51 +0200
> "Carlos R. Mafra" <crmafra2@gmail.com> wrote:
>
>> On Mon 12.Oct'09 at  9:54:38 -0700, Jesse Barnes wrote:
>> > >
>> > > Nope, unfortunately, it's not helping on my T400 laptop.  I'm
>> > > still getting huge amounts of glitching and tearing with this
>> > > patch applied against -rc3.
>> > >
>> > > What I'm using for now to fix up my system is this patch.
>> > >
>> >
>> > How about this one?  I have one more idea to try out if this doesn't
>> > work (hacking on it now).
>>
>> I was also experiencing something very similar to Theodore's bug
>> report and, at least for me, the patch below fixed the issue (the
>> previous one also had no effect).
>
> Cool, good to hear.  Hopefully Ted and Keith will confirm too.
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 7a5fb79..1451945 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1047,7 +1047,7 @@ static void g4x_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
>        dev_priv->cfb_fence = obj_priv->fence_reg;
>        dev_priv->cfb_plane = intel_crtc->plane;
>
> -       dpfc_ctl = plane | DPFC_SR_EN | DPFC_CTL_LIMIT_1X;
> +       dpfc_ctl = plane | DPFC_CTL_LIMIT_1X;
>        if (obj_priv->tiling_mode != I915_TILING_NONE) {
>                dpfc_ctl |= DPFC_CTL_FENCE_EN | dev_priv->cfb_fence;
>                I915_WRITE(DPFC_CHICKEN, DPFC_HT_MODIFY);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
