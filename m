Return-Path: <linux-kernel-owner+w=401wt.eu-S1161358AbXDXG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161358AbXDXG5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161364AbXDXG5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:57:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161358AbXDXG5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:57:20 -0400
Date: Tue, 24 Apr 2007 08:57:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>
Cc: davidsen@posidon.tmr.com, "Kolivas, Con" <kernel@kolivas.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [REPORT] First "glitch1" results, 2.6.21-rc7-git6-CFSv5 + SD 0.46
Message-ID: <20070424065709.GB19802@elte.hu>
References: <462D2BDD.4040406@tmr.com> <200704231945.25613.edt@aei.ca> <200704231949.06108.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704231949.06108.edt@aei.ca>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ed Tomlinson <edt@aei.ca> wrote:

> > SD 0.46		1-2 FPS
> > cfs v5 nice -19	219-233 FPS
> > cfs v5 nice 0 	1000-1996
>    cfs v5 nice -10  60-65 FPS

the problem is, the glxgears portion of this test is an _inverse_ 
testcase.

The reason? glxgears on true 3D hardware will _not_ use X, it will 
directly use the 3D driver of the kernel. So by renicing X to -19 you 
give the xterms more chance to show stuff - the performance of the 
glxgears will 'degrade' - but that is what you asked for: glxgears is 
'just another CPU hog' that competes with X, it's not a "true" X client.

if you are after glxgears performance in this test then you'll get the 
best performance out of this by renicing X to +19 or even SCHED_BATCH.

	Ingo
