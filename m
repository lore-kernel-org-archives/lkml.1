Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZFUOru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZFUOru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 10:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbZFUOrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 10:47:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:63923 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZFUOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 10:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HKPCwMobnFjbtKBRm+LRnweOZNzKp8+jXMT0kXWCzQACOs+Kh+hLzzbwgZFx7EpNbt
         zXAaYubBAWsTcvIwkvMG1iIxRHhZ+P2Lzc1zePI72TwubQXqC/dLqfAM+hVchfvvyS2u
         uVjiLlfe+w9lzGh1HfhxP5GXHifTGRxLin05E=
Subject: Re: [git pull] drm: previous pull req + 1.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0906201741290.3119@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <1245542690.6104.6.camel@localhost>
	 <alpine.LFD.2.01.0906201741290.3119@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 17:47:38 +0300
Message-Id: <1245595658.4805.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 17:42 -0700, Linus Torvalds wrote:
> 
> On Sun, 21 Jun 2009, Maxim Levitsky wrote:
> > 
> > Something from this tree breaks my i965.
> > Using -git just before this was pulled,
> > 
> >  a552f0af753eb4b5bbbe9eff205fe874b04c4583 works, but using latest git
> > 
> > makes google earth stall, it doesn't update its main window. It appears
> > that openining and closing its menu, allows it to progress frame after
> > frame. No crashes hangs however.
> 
> Can you bisect? There's not a tons of commit there, so it shouldn't be 
> more than a couple of recompiles/reboots, and you'd be able to pinpoint 
> the exact commit that breaks. That will help people figure it out, or at 
> worst just pinpoint what we need to revert.
> 
> 		Linus


Here the result:


> 52dc7d32b88156248167864f77a9026abe27b432 is first bad commit
> commit 52dc7d32b88156248167864f77a9026abe27b432
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Sat Jun 6 09:46:01 2009 +0100
> 
>     drm/i915: Clear fence register on tiling stride change.
>     
>     The fence register value also depends upon the stride of the object, so we
>     need to clear the fence if that is changed as well.
>     
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>     [anholt: Added 8xx and 965 paths, and renamed the confusing
>     i915_gem_object_tiling_ok function to i915_gem_object_fence_offset_ok]
>     Signed-off-by: Eric Anholt <eric@anholt.net>
> 



However I can't reproduce the situation I have earlier, maybe I have changed some settings, don't know.
Now, the bad behavior (and I reproduced it many times, is that GE shows incorrect textures 
(like they are divided in tiny interlaced rows, one row ok, other contain image from other part of world), only few textures are such
it seems logical that this is related to tiling.

Also, if I maximize it, it hangs. This seems to be a separate bug introduced by these series.

commit 43813f399c72aa22e01a680559c1cb5274bf2140 both textures and maximize broken
commit 52dc7d32b88156248167864f77a9026abe27b432, shows this incorect textures, but doesn't hang the system on maximize
commit 8c4b8c3f34de4e2da20df042bba173fe557f8b45 works just fine



Unfortunaly I have no time now to do another bisect now, I try to do such as soon as possible.

Thanks,
	Maxim Levitsky


