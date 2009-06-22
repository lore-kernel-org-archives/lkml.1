Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZFVSJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZFVSJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZFVSJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:09:34 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:35925 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZFVSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EE1yUgiI8n8DX7kK/8AeucyJh31ZAEA/O9nDAlUeGnnz3R28FxRbAPJb0JYGs14CBX
         8c3KgqFB4fTXsXj0lUZObegkV8ppKlB6cTw38bgFHT2MtJ2y7t6I0L45/0iQTBM1PKCN
         2vEjEyoHzBWQ1ayZs5ZN0XC5V5DW5P2vh0/98=
Subject: Re: [git pull] drm: previous pull req + 1.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <1245619456.4937.35.camel@tiger>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <1245542690.6104.6.camel@localhost>
	 <alpine.LFD.2.01.0906201741290.3119@localhost.localdomain>
	 <1245595658.4805.17.camel@localhost>  <1245619456.4937.35.camel@tiger>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 21:09:31 +0300
Message-Id: <1245694171.6673.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 22:24 +0100, Chris Wilson wrote:
> On Sun, 2009-06-21 at 17:47 +0300, Maxim Levitsky wrote:
> > > 52dc7d32b88156248167864f77a9026abe27b432 is first bad commit
> > > commit 52dc7d32b88156248167864f77a9026abe27b432
> > > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > > Date:   Sat Jun 6 09:46:01 2009 +0100
> 
> The error here seems to be my presumption that only the i915 was using
> fences for GPU access. (In hindsight, it seems obvious that we do not
> know why the fence was allocated for the object and so if it has
> outstanding rendering, we must assume that it is using a fence for a
> rendering op.)
> 
> To confirm, please can you try:
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c
> b/drivers/gpu/drm/i915/i915_gem.c
> index fd2b8bd..0735518 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -2347,7 +2347,7 @@ i915_gem_object_put_fence_reg(struct
> drm_gem_object *obj)
>          * therefore we must wait for any outstanding access to complete
>          * before clearing the fence.
>          */
> -       if (!IS_I965G(dev)) {
> +       if (1) {
>                 int ret;
>  
>                 i915_gem_object_flush_gpu_write_domain(obj);

Nope, same thing.

I use commit 87ef92092fd092936535ba057ee19b97bb6a709a + this patch
Note that GE doesn't hang the system when maximizing it.

It is for sure tiled textures accessed incorrectly, same behavior
observed in many games (they still run though)

Best regards,
	Maxim Levitsky

