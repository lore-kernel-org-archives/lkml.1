Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbYBTK15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbYBTK15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYBTK1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:27:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbYBTK1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:27:48 -0500
Date: Wed, 20 Feb 2008 11:27:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
	check
Message-ID: <20080220102721.GE3881@elte.hu>
References: <47B95C4D.6080000@cn.fujitsu.com> <20080218134720.GA28851@elte.hu> <47BA299A.3040207@cn.fujitsu.com> <20080219185009.122ED2701BA@magilla.localdomain> <47BB7922.1010400@cn.fujitsu.com> <20080220011822.C510B2701BA@magilla.localdomain> <47BB83E2.1030504@cn.fujitsu.com> <20080220014419.B85D02701BA@magilla.localdomain> <47BB8F05.3050001@cn.fujitsu.com> <20080220024928.0EE172701BA@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220024928.0EE172701BA@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> > I spent some time read you mail carefully and dig into the code again.
> > 
> > And yes, you are right. It's possible that SA_ONSTACK has been cleared
> > before the second signal on the same stack comes.
> 
> It's not necessary for SA_ONSTACK to have "been cleared", by which I 
> assume you mean a sigaction call with SA_ONSTACK not set in sa_flags.  
> That is indeed possible, but it's not the only case your patch broke.  
> It can just be a different signal whose sigaction never had 
> SA_ONSTACK, when you are still on the signal stack from an earlier 
> signal that did have SA_ONSTACK.
> 
> > So this patch is wrong :( . I will revise the other 4 patches.
> 
> For 2 and 3, I would rather just wait until we unify signal.c anyway.

ok, i've removed these patches from x86.git#testing for now:

 Subject: x86: improve the signal stack overflow logic, 32-bit
 Subject: x86: add a signal stack overflow check, 64-bit
 Subject: x86: add signal stack overflow check, 32-bit

and will wait for a resubmission and an Ack from Roland.

	Ingo
