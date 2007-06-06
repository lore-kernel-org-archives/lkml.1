Return-Path: <linux-kernel-owner+w=401wt.eu-S935226AbXFFUUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226AbXFFUUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932343AbXFFUU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:20:28 -0400
Received: from waste.org ([66.93.16.53]:41568 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbXFFUU1 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:20:27 -0400
Date: Wed, 6 Jun 2007 15:19:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070606201955.GG11115@waste.org>
References: <20070604173710.GR11166@waste.org> <1181002734.25878.56.camel@localhost.localdomain> <1181010675.25878.140.camel@localhost.localdomain> <20070605041803.GO11115@waste.org> <20070605104353.GA7309@elte.hu> <20070605190806.GA18503@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605190806.GA18503@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 09:08:06PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Matt, could you send me your .config too? Maybe i can reproduce it 
> > with your config.
> 
> ok, got it (off-list) and you seem to have the default HZ=250. Could you 
> change it to HZ=1000 - does the delay get alot smaller?

Well I'm too busy/lazy to reboot at the moment, but I've reproduced
this behavior with the following:

watchdelta.py:
import time

last = time.time()
while 1:
    t = time.time()
    delta = t - last
    if delta > .5:
        print delta
    last = t

$ nice -n 20 python watchdelta.py 
0.696138858795
0.772134065628
0.852141141891
2.22020101547
0.600075960159
0.528147935867
0.556170940399
0.536160945892
0.572169065475
0.672204971313
0.576174974442
0.640056848526
0.548166036606
0.568286895752
0.544052124023
0.572114944458
0.534852027893
0.596146821976
0.552155971527
0.552098035812
0.564115047455
0.546761989594
0.63211107254
0.876178026199
0.584072828293
0.544088125229
0.760088920593
1.07612800598
0.552155017853
...

At load=1 (the first several lines), this prints out messages
sporadically. At higher loads, every iteration is a >.5s delay. So
it's probably not particular to lguest at all.

-- 
Mathematics is the supreme nostalgia of our time.
