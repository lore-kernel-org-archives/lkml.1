Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbZICVSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbZICVSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932278AbZICVSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:18:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55062 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbZICVSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:18:40 -0400
Date: Thu, 3 Sep 2009 23:18:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, jeremy.fitzhardinge@citrix.com,
       stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
	is cache aligned
Message-ID: <20090903211805.GB12566@elte.hu>
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA031DE.2070109@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 09/03/2009 01:45 PM, Jeremy Fitzhardinge wrote:
> > 
> > Two problems:
> > 
> >     * gcc generates %gs: references for stack-protector, but we use %fs
> >       for percpu data (because restoring %fs is faster if it's a null
> >       selector; TLS uses %gs).  I guess we could use %fs if
> >       !CONFIG_CC_STACKPROTECTOR, or %gs if we are using it (though that
> >       has some fiddly ramifications for things like ptrace).
> 
> Well, by touching two segments we're getting the worst of both 
> worlds, so at least assuming some significant number of real-world 
> deployments use CC_STACKPROTECTOR, we really don't want to 
> pessimize that case too much.

Fedora has stackprotector enabled so it's used in a widespread way.

	Ingo
