Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYAJKDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYAJKDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYAJKCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:02:54 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45525 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944AbYAJKCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:02:53 -0500
Date: Thu, 10 Jan 2008 12:02:50 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <1199919548.6245.74.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
  <1199641910.8215.28.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> 
 <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
 <1199919548.6245.74.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Wed, 9 Jan 2008, Matt Mackall wrote:
> Huh, that's a fairly negligible change on your system. Is that with or
> without the earlier patch? That doesn't appear to change much here.
> Guess I'll have to clean up my stats patch and send it to you.

Ok, if I apply both of the patches, I get better results for SLOB:

[ the minimum, maximum, and average are captured from 10 individual runs ]

                        Total   Free (kB)             Used (kB)
                        (kB)    min   max   average   min  max  average
  SLUB (no debug)       26536   23868 23892 23877.6   2644 2668 2658.4
  SLOB (both patches)   26548   23612 23860 23766.4   2688 2936 2781.6
  SLOB (two lists)      26548   23456 23708 23603.2   2840 3092 2944.8
  SLOB (vanilla)        26548   23472 23640 23579.6   2908 3076 2968.4
  SLAB (no debug)       26544   23316 23364 23343.2   3180 3228 3200.8
  SLOB (merge fix)      26548   23260 23728 23385.2   2820 3288 3162.8
  SLUB (with debug)     26484   23120 23136 23127.2   3348 3364 3356.8

I'll double check the results for SLUB next but it seems obvious that your 
patches are a net gain for SLOB and should be applied. One problem though 
with SLOB seems to be that its memory efficiency is not so stable. Any 
ideas why that is?

			Pekka
