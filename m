Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYITGPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYITGPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 02:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYITGPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 02:15:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57828 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYITGPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 02:15:13 -0400
Date: Sat, 20 Sep 2008 08:14:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Valdis.Kletnieks@vt.edu, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: c1e_idle: don't mark TSC unstable if CPU has
	invariant TSC
Message-ID: <20080920061457.GE25713@elte.hu>
References: <20080918191210.GD23287@alberich.amd.com> <27087.1221766532@turing-police.cc.vt.edu> <20080919172019.GA16896@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919172019.GA16896@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Currently the kernel assumes TSC is stable and there are various 
> places where Linux might spot when TSC is unstable. c1e_idle is one 
> such place. But it's wrong to mark TSC unstable for all AMD CPUs in 
> this function as newer CPU families have TSC's that are P- and C-state 
> invariant.

i agree with the purpose of the patch (as it flags the first really sane 
TSC implementation on x86!!!) - but it would be nice to indicate this in 
a different CPU feature bit other than X86_FEATURE_CONSTANT_TSC, to 
reduce confusion. Perhaps introduce a virtual CPU feature bit for that?

	Ingo
