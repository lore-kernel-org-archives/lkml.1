Return-Path: <linux-kernel-owner+w=401wt.eu-S934015AbXCVKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015AbXCVKEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933913AbXCVKEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:04:44 -0400
Received: from mail23.syd.optusnet.com.au ([211.29.133.164]:41509 "EHLO
	mail23.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030342AbXCVKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:04:43 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.21-rc4-mm1
Date: Thu, 22 Mar 2007 21:04:06 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4602413C.6000504@shadowen.org> <46025100.7060103@shadowen.org>
In-Reply-To: <46025100.7060103@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703222104.06507.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 20:48, Andy Whitcroft wrote:
> Andy Whitcroft wrote:
> > Andy Whitcroft wrote:
> >> Andrew Morton wrote:
> >>> Temporarily at
> >>>
> >>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> >>>
> >>> Will appear later at
> >>>
> >>>  
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc
> >>>4/2.6.21-rc4-mm1/
> >>
> >> [All of the below is from the pre hot-fix runs.  The very few results
> >> which are in for the hot-fix runs seem worse if anything.  :(  All
> >> results should be out on TKO.]
> >>
> >>> - Restored the RSDL CPU scheduler (a new version thereof)
> >>
> >> Unsure if the above is the culprit but there seems to be a smattering of
> >> BUG's in kernbench from the schedular on several systems, and panics
> >> which do not fully dump out.
> >>
> >> elm3b239 is about 2/4 kernbench being the test in progress when we
> >> blammo in both failed tests, elm3b234 doesn't boot at all.
> >
> > Well I have one result through for backing RSDL out on elm3b239 and that
> > does indeed seem to give us a successful boot and test.  peterz has
> > pointed me to an incremental patch from Con which I'll push through
> > testing and see if that sorts it out.
>
> Ok, tested the patch below on top of 2.6.21-rc4-mm1 and this seems to
> fix the problem:
>
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc4-mm1-rsdl-0.32.p
>atch
>
> Hard to tell from that patch whether it will be fixed in the changes
> already committed to the next -mm.
>
> Its possible that it may be fixed by the following patch:
>
>     sched-rsdl-improvements.patch
>
> Which has the following slipped in at the end of the changelog:
>
>     A tiny change checking for MAX_PRIO in normal_prio()
>     may prevent oopses on bootup on large SMP due to
>     forking off the idle task.
>
> Con, are all the changes in the 0.32 patch above with akpm?

Yes he's queued everything in that patch you tested for the next -mm. Thanks 
very much for testing it.

-- 
-ck
