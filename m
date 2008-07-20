Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYGTQkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYGTQkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYGTQkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:40:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36362 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011AbYGTQkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:40:40 -0400
Date: Sun, 20 Jul 2008 18:40:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@keyaccess.nl>,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [patch 5/3] fastboot: sync the async execution before
	late_initcall and move level 6s (sync) first
Message-ID: <20080720164000.GA10119@elte.hu>
References: <20080720085924.122feb2b@infradead.org> <20080720090041.5924f5ff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720090041.5924f5ff@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] fastboot: sync the async execution before late_initcall and move level 6s (sync) first
> 
> Rene Herman points out several cases where it's basically needed to 
> have all level 6/6a/6s calls done before the level 7 (late_initcall) 
> code runs. This patch adds a sync point in the transition from the 6's 
> to the 7's.
> 
> Second, this patch makes sure that level 6s (sync) happens before the 
> async code starts, and puts a user in driver/pci in this category that 
> needs to happen before device init.

incidentally, this fixed an USB related boot hang i found today on one 
of my testsystems running tip/master (which had patches 1-2-3 already), 
which i was about to report. Good spotting Rene! I've applied patches 
4/5 to tip/fastboot.

	Ingo
