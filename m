Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYDUPyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYDUPyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYDUPx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:53:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbYDUPx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:53:57 -0400
Date: Mon, 21 Apr 2008 17:53:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kai <epimetreus@fastmail.fm>
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Serious performance regression in Wine applications and Linux
	2.6.24.*
Message-ID: <20080421155339.GC31716@elte.hu>
References: <1206310206.17373.1243881033@webmail.messagingengine.com> <2c0942db0803231522w7c66f168xf7fea72d135ba395@mail.gmail.com> <1206341873.32060.1243929851@webmail.messagingengine.com> <20080327091711.GD30918@elte.hu> <1207250856.9779.1245934881@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207250856.9779.1245934881@webmail.messagingengine.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Kai <epimetreus@fastmail.fm> wrote:

> I did, however, test it on 2.6.25-rc8, and attached is the output of 
> cfs-debug-info.sh

your vmstat:

-- vmstat: 
--procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 3  0      0 870540    340 746184    0    0   952   137  198 4752 21 12 60  7
 1  0      0 870952    340 746320    0    0   128     0  356 17723 28 23 50  0
 1  0      0 872224    340 746320    0    0     0    21  394 18066 30 20 50  0
 1  0      0 872244    340 746320    0    0     0     0  353 17987 29 22 50  0
 1  0      0 871416    340 746320    0    0     0     0  392 17971 28 22 50  0

suggests that there's a constant 50% idle time. Probably one core 
running X and the client, the other core staying idle?

	Ingo
