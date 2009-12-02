Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZLBSxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZLBSxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZLBSxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:53:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:46991 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbZLBSxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:53:22 -0500
Date: Wed, 2 Dec 2009 19:53:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: some recent scheduler patches
Message-ID: <20091202185328.GI31517@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm just been looking through some of the recent scheduler patches
while bisecting something...

83f54960c11a14942ab00b54c51e91906b9d8235: sched: for_each_domain() vs RCU
I don't see what is the step that causes FAIL? sched-domains code is
using synchronize_sched(), so that part should be safe.

And b8a543ea5a5896830a9969bacfd047f9d15940b2... This changelog is not
correct to start with. The _idx stuff does not just shift the time
that balancing decisions are made, it damps balancing choices to be
more conservative if they might have been wrong over more than a single
instant sample.

And secondly there is no reason give for the change. Ditto for a lot of
other tuning changes really. Not that there was always exact reasons
for every single one of the defaults I found, but they a) always tried
to get reasonable performance with as conservative balancing as
possible (ie. so 2 different tunings with no distinguishable difference
then tuning that result in fewer task movements would be preferred).
And b) they were relatively well tested.

Are people really not reporting enough regressions against CFS that it
is time to just tweak things?

