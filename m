Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595Ab0ANUSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0ANUSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572Ab0ANUSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:18:05 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37032 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab0ANUSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=uW1h5K2kbHuQFZNFOiACZXR7p0WnBSwEhL7sewE9tchY0b64eud82Q41Hq2Bq/6+L6
         hsNWWINWpzqbCZfPNALcm2V5U3y/R0CLgfTRi+/15icZQttL55bONsDNw2uKFzEm/rPw
         /POT7NUbEw7U19/9u5tnmzFsNVWPc/ECrJmHU=
MIME-Version: 1.0
In-Reply-To: <20100114193118.GA1203@emergent.ellipticsemi.com>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	 <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	 <20100113133357.67f9df6d@jbarnes-piketon>
	 <4B4E403C.1050509@cs.helsinki.fi>
	 <20100113165530.2a7e7645@jbarnes-piketon>
	 <4B4F6D5F.10008@cs.helsinki.fi>
	 <20100114193118.GA1203@emergent.ellipticsemi.com>
Date: Thu, 14 Jan 2010 22:18:00 +0200
X-Google-Sender-Auth: 7b46ab5106601d0d
Message-ID: <84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
Subject: Re: Linux 2.6.33-rc4
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 9:31 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 21:15 Thu 14 Jan     , Pekka Enberg wrote:
>> OK, I think I am seeing a different kind of flicker now. It doesn't
>> happen anywhere as often as before (which is probably why I missed it
>> last night). The flicker is more like a flash of some other window
>> whereas the flicker before used to "shake" the screen.
>>
>> Does this ring a bell?
>
> Your symptoms sound identical to mine on my ThinkPad T500 laptop, as
> described in http://bugs.freedesktop.org/show_bug.cgi?id=25809.
>
> This is the patch I am currently applying locally which solves all my
> problems.
>
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> index f4b4aa2..4fb5911 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -914,7 +914,7 @@ static void intel_find_lvds_downclock(struct drm_device *dev,
>        mutex_unlock(&dev->mode_config.mutex);
>        if (temp_downclock < panel_fixed_mode->clock) {
>                /* We found the downclock for LVDS. */
> -               dev_priv->lvds_downclock_avail = 1;
> +               dev_priv->lvds_downclock_avail = 0;
>                dev_priv->lvds_downclock = temp_downclock;
>                DRM_DEBUG_KMS("LVDS downclock is found in EDID. "
>                                "Normal clock %dKhz, downclock %dKhz\n",

Should I try just this or combine it with Jesse's patch?
