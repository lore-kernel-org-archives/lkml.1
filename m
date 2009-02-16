Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZBPJ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZBPJ1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZBPJ10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:27:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57699 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZBPJ1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:27:25 -0500
Date: Mon, 16 Feb 2009 10:27:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216092712.GJ6182@elte.hu>
References: <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain> <20090215110104.GB31351@elte.hu> <20090215180355.GA2273@localhost.localdomain> <20090215193102.GA16873@elte.hu> <20090216084223.GA2641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216084223.GA2641@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


scheduler clock deltas look healthy at first sight:

$ grep clock-delta cfs-debug-info-2009.02.16-08.09.17

clock-delta                        :                  285
clock-delta                        :                  313
clock-delta                        :                  286
clock-delta                        :                  311
clock-delta                        :                  348
clock-delta                        :                  301
clock-delta                        :                  386
clock-delta                        :                  318
clock-delta                        :                  275
clock-delta                        :                  283
clock-delta                        :                  343
clock-delta                        :                  341
clock-delta                        :                  318
clock-delta                        :                  295
clock-delta                        :                  330
clock-delta                        :                  311
clock-delta                        :                  286
clock-delta                        :                  333
clock-delta                        :                  309
clock-delta                        :                  369
clock-delta                        :                 1102
clock-delta                        :                  323
clock-delta                        :                  283
clock-delta                        :                  333
clock-delta                        :                  316
clock-delta                        :                  300
clock-delta                        :                  278
clock-delta                        :                  286
clock-delta                        :                  364
clock-delta                        :                  298
clock-delta                        :                  326
clock-delta                        :                  353
clock-delta                        :                  323
clock-delta                        :                  286
clock-delta                        :                  286
clock-delta                        :                  256
clock-delta                        :                  343
clock-delta                        :                  305
clock-delta                        :                  363
clock-delta                        :                  283
clock-delta                        :                  280
clock-delta                        :                  301
clock-delta                        :                  283
clock-delta                        :                  308
clock-delta                        :                  316
clock-delta                        :                  315
clock-delta                        :                  318
clock-delta                        :                  311
clock-delta                        :                  298
clock-delta                        :                  343
clock-delta                        :                  276
clock-delta                        :                  324
clock-delta                        :                  285
clock-delta                        :                  268
clock-delta                        :                  281
clock-delta                        :                  280
clock-delta                        :                  338
clock-delta                        :                 1060
clock-delta                        :                  315
clock-delta                        :                  315
clock-delta                        :                  298
clock-delta                        :                  308
clock-delta                        :                  281
clock-delta                        :                  323
clock-delta                        :                  321
clock-delta                        :                  389
clock-delta                        :                  288
clock-delta                        :                  355
clock-delta                        :                  295
clock-delta                        :                  284
clock-delta                        :                 1037
clock-delta                        :                  298
clock-delta                        :                  348
clock-delta                        :                  328
clock-delta                        :                  305
clock-delta                        :                  358
clock-delta                        :                  340
clock-delta                        :                  406
clock-delta                        :                  323
clock-delta                        :                  306
clock-delta                        :                  295
clock-delta                        :                  294
clock-delta                        :                  288
clock-delta                        :                  363
clock-delta                        :                  296
clock-delta                        :                  321
clock-delta                        :                  278
clock-delta                        :                  338
clock-delta                        :                  291
clock-delta                        :                  318
clock-delta                        :                  331
clock-delta                        :                  305
clock-delta                        :                  353
clock-delta                        :                  319
clock-delta                        :                  338
clock-delta                        :                  286
clock-delta                        :                  309
clock-delta                        :                  298
clock-delta                        :                  316

	Ingo
