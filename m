Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbYHNJLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbYHNJLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYHNJLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:11:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbYHNJLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:11:38 -0400
Date: Thu, 14 Aug 2008 11:11:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.org>,
       lizf@cn.fujitsu.com, jeff.chua.linux@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
	(take 2)
Message-ID: <20080814091120.GA18771@elte.hu>
References: <1218491731-10673-1-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218491731-10673-1-git-send-email-maxk@qualcomm.com>
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


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> From: Max Krasnyansky <maxk@qualcomm.org>
> 
> For some reason we had two parsers registered for maxcpus=. One in init/main.c 
> and another in arch/x86/smpboot.c. So I nuked the one in arch/x86.
> 
> Also 64-bit kernels used to handle maxcpus= as documented in
> Documentation/cpu-hotplug.txt. CPUs with 'id > maxcpus' are initialized
> but not booted. 32-bit version for some reason ignored them even though
> all the infrastructure for booting them later is there.
> 
> In the current mainline both 64 and 32 bit versions are broken.
> This patch restores the correct behaviour. I've tested x86_64 version on
> 4- and 8- way Core2 and 2-way Opteron based machines. Various config
> combinations SMP, !SMP, CPU_HOTPLUG, !CPU_HOTPLUG.
> Booted with maxcpus=1 and maxcpus=4, etc. Everything is working as expected.
> 
> So far we've received two reports from different people confirming that 32-bit 
> version also works fine, both on dual core laptops and 16way server machines.
> 
> This version fixes visws breakage pointed out by Ingo.

applied to tip/x86/urgent, thanks Max.

	Ingo
