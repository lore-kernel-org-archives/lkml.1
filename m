Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZBUO5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZBUO5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 09:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZBUO5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 09:57:24 -0500
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:55614 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZBUO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 09:57:24 -0500
Date: Sat, 21 Feb 2009 15:57:06 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED && PACTH AVAILABLE] [drm:i915_initialize] *ERROR* can
 not ioremap virtual address for ring buffer
Message-ID: <20090221155706.5f6d2184@fastwebnet.it>
In-Reply-To: <20090221131209.GB13134@silver.sucs.org>
References: <20090221110011.030cb16d@fastwebnet.it>
 <20090221121944.GA21090@silver.sucs.org>
 <20090221134933.368c2709@fastwebnet.it>
 <20090221135233.58fbae0b@fastwebnet.it>
 <20090221130521.GA13134@silver.sucs.org>
 <20090221131209.GB13134@silver.sucs.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 13:12:09 +0000
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> > Doh. Scratch that idea...  
> 
> Hmm does the patch mentioned on
> http://marc.info/?l=linux-kernel&m=123455194230641&w=2 help the DRM
> error message (and if so does the mtrr weirdness still happen)?

With that patch the error is gone :)

---------- patch here for reference ---------------

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 81f1cff..2d797ff 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -202,7 +202,7 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
                dev_priv->ring.map.flags = 0;
                dev_priv->ring.map.mtrr = 0;

-               drm_core_ioremap(&dev_priv->ring.map, dev);
+               drm_core_ioremap_wc(&dev_priv->ring.map, dev);

                if (dev_priv->ring.map.handle == NULL) {
                        i915_dma_cleanup(dev);
--------------------------------------------------

$ cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x07f000000 ( 2032MB), size=   16MB, count=1: uncachable
reg02: base=0x07e800000 ( 2024MB), size=    8MB, count=1: uncachable
reg03: base=0x07e700000 ( 2023MB), size=    1MB, count=1: uncachable
reg04: base=0x080000000 ( 2048MB), size=  256MB, count=2: write-combining
                                                      ^^^


Another "problem": every time I switch from X to a text console I get
this:

[  156.729311] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1


It seems harmless but I report it anyway.


-- 
	Paolo Ornati
	Linux 2.6.29-rc5-00276-g2ec77fc-dirty on x86_64
