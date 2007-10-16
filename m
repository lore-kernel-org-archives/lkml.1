Return-Path: <linux-kernel-owner+w=401wt.eu-S1765490AbXJPJq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765490AbXJPJq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbXJPJqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:46:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbXJPJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:46:48 -0400
Date: Tue, 16 Oct 2007 11:46:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071016094631.GA10649@elte.hu>
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071016091012.GB24341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016091012.GB24341@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > While running kernbench with the 2.6.23-git8 following oops is 
> > produced
> > 
> > Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP: 
> >  [<ffffffff8033f347>] __rb_rotate_left+0x7/0x70
> 
> that looks nasty ...
> 
> and -git8 should have the v2.6.23 scheduler code in essence.

ah, this is likely with the recent scheduler commits included as well, 
right?

if it's reproducable, could you try with group scheduling disabled, i.e. 
with:

  # CONFIG_FAIR_GROUP_SCHED is not set

as that would be the main suspect for such type of a crash.

	Ingo
