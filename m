Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbZLOJwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbZLOJwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbZLOJwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:52:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbZLOJwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:52:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Tue, 15 Dec 2009 10:51:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <200912142038.09254.arnd@arndb.de> <20091214125024.77601d7e@jbarnes-piketon>
In-Reply-To: <20091214125024.77601d7e@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912151051.44131.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19gaHb4KeDUbCmxg95Ugmho4MBWAPPw05bAISY
 X09f9b+laEZuaP87qo67Etpp4EjiLXPY9tfV485W+CQi8v7l82
 sp1xH8jwYAbDeOME7kMfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009, Jesse Barnes wrote:
> This patch removes the suspect portion of the dynamic clock control
> code.  Hopefully it'll be as stable as powersave=0 in your config
> (assuming powersave=0 works :).

Ok, great! The machine is still running  fine with powersave=0 so 
far. I'll try your patch after some more uptime.

	Arnd

> Jesse Barnes, Intel Open Source Technology Center
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_d
> index 279dc96..b8730de 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -3825,8 +3825,6 @@ void intel_decrease_renderclock(struct drm_device *dev)
>                 /* Down to minimum... */
>                 gcfgc &= ~GM45_GC_RENDER_CLOCK_MASK;
>                 gcfgc |= GM45_GC_RENDER_CLOCK_266_MHZ;
> -
> -               pci_write_config_word(dev->pdev, GCFGC, gcfgc);
>         } else if (IS_I965G(dev)) {
>                 u16 gcfgc;

