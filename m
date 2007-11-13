Return-Path: <linux-kernel-owner+w=401wt.eu-S1763932AbXKMWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763932AbXKMWEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760825AbXKMWD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:03:58 -0500
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:4809 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760189AbXKMWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:03:57 -0500
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: [BUG] New Kernel Bugs
Cc: akpm@linux-foundation.org, alsa-devel@alsa-project.org,
       bugme-daemon@bugzilla.kernel.org, bunk@kernel.org, cate@cateee.net,
       davem@davemloft.net, liml@rtr.ca, linux-ide@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, mingo@elte.hu, netdev@vger.kernel.org,
       protasnb@gmail.com, ray-lk@madrabbit.org
In-reply-To: <1194976238.15745.17.camel@rukbat>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <4739C1B0.8000803@cateee.net> <2c0942db0711130757g295add20re0ee423b84921d28@mail.gmail.com> <20071113170141.GD4250@stusta.de> <1194976238.15745.17.camel@rukbat>
Message-Id: <E1Is3rO-0002ze-1L@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Tue, 13 Nov 2007 23:03:54 +0100
X-OriginalArrivalTime: 13 Nov 2007 22:03:54.0348 (UTC) FILETIME=[14C89AC0:01C82641]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Romano Giannetti wrote:
> This was what I did in my (in the end almost successful) bisecting when
> trying to find the mmc problem (see the thread named "2.6.24-rc1 eat my
> SD card"). This is true in theory, but it has some problem. The "this
> commit does not compile is the easiest and in man git-bisect it's
> explained how to solve it. The changes in .config options, added or
> removed, are another problem when jumping back and forth from version.
> 
> The main problem I had, and that stopped me to arrive to a definite is
> this situation:
[...] 
> (d was the series to change drivers to use sg helpers, and g was a "fix
> fallout from sg helpers" patch). Now I have a series of kernels (d, e,
> f) that did not work at all and so I cannot mark them good or bad. With
> the number of patches added in the free-for-all week, this is a very
> probable scenario. There is a way out from this using bisect?

I think there are three strategies you can use in this case:
- create a kernel config that is as simple as possible, but still supports
  your hardware and reproduces your problem; a simpler config will often
  avoid compilation issues in parts of the kernel that you're not using
  anyway and has the benefit of speeding up the compiles too

- if you know/suspect in what part of the tree the bug is, first limit the
  bisection to that; you will have to verify that you did indeed find the
  correct (broken) change by doing a compile for the "last good commit + 1"

- if you find a broken commit, use 'git-reset --hard' to try to jump past
  the bad set of commits, but of course that does not help in the case:
    g version-bad
    f unrelated bug corrected
    e
    d the broken commit that caused your problem
    c
    b unrelated bug that breaks compilation or system introduced
    a version-good
  in that case the best you can reasonably be expected to do is report that
  you narrowed it down to "between a and g" and leave the rest to the
  developers

Cheers,
FJP
