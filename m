Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZD2H1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZD2H1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZD2H1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:27:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:10562 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZD2H1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SYlQcX/uGE10cwlucefHQPbVhsPisF8pyYECojD/bFjCopXzJsrJljAIRe3qdR36LE
         1RJnnSpJDmCY7bR2Jpp/keT2GZ6wbpOmIV5qhV4rz5RtFeDEaMBOSX1uGk2AFLpcTNzH
         RrXfzPpBxwLISrlYpnvouCLYNBDbBGixN7Tao=
MIME-Version: 1.0
In-Reply-To: <8563BBE2A1F848B3B98C1A5FAE08BD09@avitech.sk>
References: <8563BBE2A1F848B3B98C1A5FAE08BD09@avitech.sk>
Date: Wed, 29 Apr 2009 17:27:11 +1000
Message-ID: <21d7e9970904290027v1275c346p8a8f29d2fb4658fb@mail.gmail.com>
Subject: Re: KMS + fb + FBIOPUT_VSCREENINFO
From: Dave Airlie <airlied@gmail.com>
To: Peter Hanzel <hanzelpeter@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 6:32 PM, Peter Hanzel <hanzelpeter@gmail.com> wrote:
> Hello.
>
> I have tried DRM with intel KMS and it is workiing. I am using only
> framebuffer console.
> Fbcon initializes 1280x800 mode and it works like a charm.
>
> But when I try to call FBIOPUT_VSCREENINFO on /dev/fb0, it always returns
> EINVAL,
> I have checked drivers/gpu/drm/i915/intel_fb.c
> and found that
>
> intelfb_check_var        returns -EINVAL     if (var->pixclock == -1 ||
> !var->pixclock)
> intelfb_set_par             returns -EINVAL    if (var->pixclock != -1) {
> DRM_ERROR("PIXEL CLCOK SET\n");  return
>
> So the FBIOPUT_VSCREENINFO always fails.
>
> So is the change of resolution not supported through FBIOPUT_VSCREENINFO
> call?
>

The problem we've had is defining proper semantics for what happens in
multi-output systems when
 you call this ioctl. Which crtc/output should it set the mode on?
what happens if the mode isn't valid on all
connected monitors etc.

It should be quite trivial to hook up in fact I already did it once before.

I think we probably need some sysfs or fb ioctl to configure which
crtc/output combos will get controlled
by an fbset.

kms also has an option to run with one fb per crtc, which could also
be checked out. I'm not sure how much further we got with it.

Dave.

> Thanks.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
