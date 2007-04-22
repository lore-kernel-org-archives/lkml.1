Return-Path: <linux-kernel-owner+w=401wt.eu-S1030911AbXDVOgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030911AbXDVOgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030915AbXDVOgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:36:47 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:45831 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030911AbXDVOgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:36:46 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ck] Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Mon, 23 Apr 2007 00:35:53 +1000
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Michael Gerdau <mgd@technosis.de>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Matt Mackall <mpm@selenic.com>
References: <200704221441.48897.kernel@kolivas.org> <200704222218.32754.kernel@kolivas.org> <20070422142216.GA17210@1wt.eu>
In-Reply-To: <20070422142216.GA17210@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704230035.54002.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 00:22, Willy Tarreau wrote:
> On Sun, Apr 22, 2007 at 10:18:32PM +1000, Con Kolivas wrote:
> > On Sunday 22 April 2007 21:42, Con Kolivas wrote:
> >
> > Willy I'm still investigating the idle time and fluctuating load as a
> > separate issue. Is it possible the multiple ocbench processes are
> > naturally synchronising and desynchronising and choosing to sleep and/or
> > run at the same time? I can remove the idle time entirely by running
> > ocbench at nice 19 which means they are all forced to run at basically
> > the same time by the scheduler.
> >
> > Anyway the more important part is... Can you test this patch please? Dump
> > all the other patches I sent you post 045. Michael, if you could test too
> > please?
>
> OK, it's better now. All tasks equally run.

Excellent thank you very much (again!)

> X is still somewhat jerky, even 
> at nice -19. I'm sure it happens when it's waiting in the other array. We
> should definitely manage to get rid of this if we want to ensure low
> latency.

Yeah that would be correct. It's clearly possible to keep the whole design 
philosophy and priority system intact with SD and do away with the arrays if 
it becomes a continuous stream instead of two arrays but that requires some 
architectural changes. I've been concentrating on nailing all the remaining 
issues (and they kept cropping up as you've seen *blush*). However... I 
haven't quite figured out how to do that architectural change just yet either 
so let's just iron out all the bugs out of this now.

> Just FYI, the idle is often close to zero and the load is often close to
> 30, even if still fluctuating :

> Hoping this helps !

I can say without a shadow of a doubt it has helped :) I'll respin the patch 
slightly differently and post it and release as v0.46.

> Willy

-- 
-ck
