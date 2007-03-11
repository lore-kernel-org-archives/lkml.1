Return-Path: <linux-kernel-owner+w=401wt.eu-S933566AbXCKMwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbXCKMwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933574AbXCKMwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:52:45 -0400
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:42153 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933569AbXCKMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:52:43 -0400
From: Con Kolivas <kernel@kolivas.org>
To: James Cloos <cloos@jhcloos.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sun, 11 Mar 2007 23:52:13 +1100
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703111016.01154.kernel@kolivas.org> <m38xe4vtsn.fsf@lugabout.jhcloos.org>
In-Reply-To: <m38xe4vtsn.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703112352.13839.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 23:38, James Cloos wrote:
> |> See:
> |> http://webcvs.freedesktop.org/mesa/Mesa/src/mesa/drivers/dri/r200/r200_i
> |>octl.c?revision=1.37&view=markup
>
> OK.
>
> Mesa is in git, now, but that still applies.  The gitweb url is:
>
> http://gitweb.freedesktop.org/?p=mesa/mesa.git
>
> and for the version of the above file in the master branch:
>
> http://gitweb.freedesktop.org/?p=mesa/mesa.git;a=blob;f=src/mesa/drivers/dr
>i/r200/r200_ioctl.c
>
> The recursive grep(1) on mesa shows:
>
> ,----[grep -r sched_yield mesa]
>
> | mesa/mesa/src/mesa/drivers/dri/r300/radeon_ioctl.c:	    sched_yield();
> | mesa/mesa/src/mesa/drivers/dri/i915tex/intel_batchpool.c:     
> | sched_yield();
> | mesa/mesa/src/mesa/drivers/dri/i915tex/intel_batchbuffer.c:        
> | sched_yield(); mesa/mesa/src/mesa/drivers/dri/common/vblank.h:#include
> | <sched.h>   /* for sched_yield() */
> | mesa/mesa/src/mesa/drivers/dri/common/vblank.h:#include <sched.h>   /*
> | for sched_yield() */ mesa/mesa/src/mesa/drivers/dri/common/vblank.h:     
> | sched_yield();							\
> | mesa/mesa/src/mesa/drivers/dri/unichrome/via_ioctl.c:      sched_yield();
> | mesa/mesa/src/mesa/drivers/dri/i915/intel_ioctl.c:	 sched_yield();
> | mesa/mesa/src/mesa/drivers/dri/r200/r200_ioctl.c:       sched_yield();
>
> `----
>
> Thanks for the heads up.  I must've grep(1)ed the xorg subdir rather
> than the parent dir, and so missed mesa.

I just wonder what the heck all these will do to testing when using any of 
these drivers. Whether or not we do no yield, mild yield or full blown 
expiration yield, somehow or other I can't get over the feeling that if the 
code relies on yield() we can't really trust them to be meaningful cpu 
scheduler tests. This means most 3d apps out there that aren't using binary 
drivers, whether they be (fscking) glxgears, audio app visualisations or 
what...

-- 
-ck
