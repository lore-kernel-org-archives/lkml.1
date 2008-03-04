Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYCDINq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYCDINq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYCDINi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:13:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46108 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYCDINh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:13:37 -0500
Date: Tue, 4 Mar 2008 09:13:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       roland@redhat.com
Subject: Re: [patch] x86, i387: fix ptrace leakage using init_fpu()
Message-ID: <20080304081320.GA5689@elte.hu>
References: <20080303210108.GA28006@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303210108.GA28006@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> This bug is introduced by the recent i387 merge.
> 
> Current usage of unlazy_fpu() in ptrace specific routines is wrong. 
> unlazy_fpu() will not init fpu if the task never used math. So the 
> ptrace calls can expose the parent tasks FPU data in some cases.
> 
> Replace it with the init_fpu() which will init the math state, if the 
> task never used math before.

thanks Suresh, good catch! Applied to x86.git.

	Ingo
