Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbZBMTEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbZBMTEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZBMTEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:04:09 -0500
Received: from outbound-mail-150.bluehost.com ([67.222.38.40]:54882 "HELO
	outbound-mail-150.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751298AbZBMTEI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:04:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=eU3mFDbtGK0bDH26/uul0yHLSTdAXMw6m9inpjFUbxPtPBQ+xIdIcrx2xy6P1pToBMih8vovu9CWQWv833muSdP3TmPhHZ3yPcC2upjioEJ0whn3cHf7Ep+p10RJnw4v;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Diego Calleja <diegocg@gmail.com>
Subject: Re: "Can not ioremap virtual address" (was Re: [git pull] drm)
Date: Fri, 13 Feb 2009 11:04:03 -0800
User-Agent: KMail/1.9.10
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Nico Schottelius <nico-linux-20090213@schottelius.org>
References: <alpine.DEB.2.00.0902090827390.32114@skynet.skynet.ie> <200902131828.22680.diegocg@gmail.com>
In-Reply-To: <200902131828.22680.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902131104.04318.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 13, 2009 9:28 am Diego Calleja wrote:
> On Lunes 09 Febrero 2009 09:30:57 Dave Airlie escribió:
> > Hi Linus,
> >
> > Please pull the 'drm-fixes' branch from
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> > drm-fixes
>
> A commit from this merge is causing an error in my machine:
>
> commit ab657db12d7020629f26f30d287558a8d0e32b41
> Author: Eric Anholt <eric@anholt.net>
> Date:   Fri Jan 23 12:57:47 2009 -0800
>
>     drm/i915: Set up an MTRR covering the GTT at driver load.
>
>
> (found using bisection)
>
> The error:
> [   20.270956] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [   20.289492] [drm:i915_initialize] *ERROR* can not ioremap virtual
> address for ring buffer
>
> And in Xorg.0.log: (II) intel(0): direct rendering: Failed
>
>
> But...excluding that printk, everything works OK, including "direct
> rendering: Yes"...
>
> There's a related thread here: http://lkml.org/lkml/2009/2/13/139

Does this prevent the message?  We map it WC in GEM but not in 
i915_initialize...

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 81f1cff..2d797ff 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -202,7 +202,7 @@ static int i915_initialize(struct drm_device * dev, 
drm_i915
                dev_priv->ring.map.flags = 0;
                dev_priv->ring.map.mtrr = 0;

-               drm_core_ioremap(&dev_priv->ring.map, dev);
+               drm_core_ioremap_wc(&dev_priv->ring.map, dev);

                if (dev_priv->ring.map.handle == NULL) {
                        i915_dma_cleanup(dev);


-- 
Jesse Barnes, Intel Open Source Technology Center
