Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYDKH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYDKH4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbYDKH4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:56:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35656 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504AbYDKH4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:56:08 -0400
Date: Fri, 11 Apr 2008 09:55:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Karsten Wiese <fzu@wemgehoertderstaat.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set_cyc2ns_scale() remove tsc_now and ns_now
Message-ID: <20080411075554.GA6834@elte.hu>
References: <200804102331.11815.fzu@wemgehoertderstaat.de> <873apsn8g7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873apsn8g7.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> (actually it is still the wrong time -- really needs a grace period 
> during which the TSC is not used 
> ftp://firstfloor.org/pub/ak/quilt/patches/sched-clock implemented some 
> of these ideas against an older kernel)

recent CPUs have constant-freq TSCs so it's mostly a legacy issue, but 
the affected installed base is still significant to warrant a fix.

we dont really have to worry about complications like grace periods - 
higher layers in the scheduler protect against temporary sched_clock() 
outliers. So i think this can all be done much simpler. Just get rid of 
the global cpu_khz notion, sched_clock() should simply follow the ->freq 
value - and that's it.

	Ingo
