Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYL2Jez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYL2Jez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 04:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYL2Jer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 04:34:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46378 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbYL2Jeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 04:34:46 -0500
Date: Mon, 29 Dec 2008 10:34:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081229093425.GB27293@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu> <4958120F.4060804@zytor.com> <86802c440812281606o6e8fbde1ub2e5055f83fea47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440812281606o6e8fbde1ub2e5055f83fea47@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sun, Dec 28, 2008 at 3:55 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Ingo Molnar wrote:
> >>
> >> ok, agreed. I was hoping for some more generic workaround but nothing
> >> seemed to keep gcc from inlining such functions.
> >>
> >
> > Other than blacklisting those gcc versions.  It's pretty easy to
> > understand how a bug like that could creep in, since one of the main
> > improvements of the early gcc4 series was better inlining as an
> > optimization.
> 
> 1. one time path add one dummy printk

dummy printks are not a good idea at all. Often the weak versions are the 
ones that get used and it would be very annoying if there was a per boot 
(or even per syscall!) 'dummy printk'.

> 2. multi path, could move it to another file.
> could add one like kernel/weak.c to collect those ...

that pretty much removes the advantages of __weak symbols: to provide 
default implementations for various functionality, without having to do
#ifdefs. The default implementation will often want to be near the usage
site - so these bugs will reoccur again and again.

	Ingo
