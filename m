Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYLHMxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYLHMxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYLHMx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:53:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38744 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbYLHMx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:53:26 -0500
Date: Mon, 8 Dec 2008 13:53:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: fix sd_parent_degenerate on non-numa smp machine
Message-ID: <20081208125319.GD16560@elte.hu>
References: <b040c32a0812071847x351c0315pb2cdb59150a59e79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0812071847x351c0315pb2cdb59150a59e79@mail.gmail.com>
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


* Ken Chen <kenchen@google.com> wrote:

> The addition of SD_SERIALIZE flag added to SD_NODE_INIT prevented top level
> dummy numa sched_domain to be properly degenerated on non-numa smp machine.
> The reason is that in sd_parent_degenerate(), it found that the child and
> parent does not have comon sched_domain flags due to SD_SERIALIZE.  However,
> for non-numa smp box, the top level is a dummy with a single sched_group.
> 
> Filter out SD_SERIALIZE if it is on non-numa machine to properly degenerate
> top level node sched_domain.  this will cut back some of the sd domain walk
> in the load balancer code.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>

applied to tip/sched/core, thanks Ken!

	Ingo
