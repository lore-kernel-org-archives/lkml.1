Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYJAIsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYJAIsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJAIsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:48:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbYJAIsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:48:31 -0400
Date: Wed, 1 Oct 2008 10:48:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used
	uninitialized
Message-ID: <20081001084825.GA25009@elte.hu>
References: <20081001080150.GC25832@elte.hu> <1222849017-10896-1-git-send-email-steven@uplinklabs.net> <20081001082930.GB31009@elte.hu> <f488382f0810010136t6280c10dg80458e3e9f02f598@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810010136t6280c10dg80458e3e9f02f598@mail.gmail.com>
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


* Steven Noonan <steven@uplinklabs.net> wrote:

> I was kind of worried about being exceedingly verbose, but I 
> understand your point perfectly. I'm going to resend the patch with an 
> appropriately verbose comment.
> 
> As always, I appreciate the criticism. Thank you! :)

I have yet to meet a too verbose commit log, and i've seen many - so 
there's basically no way you can stretch. Our problem 99% of the time is 
that commit logs are either not verbose at all, or are structured in a 
way that makes it hard to interpret them.

If you think a change is too verbose, you could start using the 
'Impact:' line convention we recently started using in the x86 tree. 
Something like:

 serial, 8250.c: fix warning: 'i' may be used uninitialized

 Impact: cleanup, fix bogus gcc warning

 serial_unlink_irq_chain() does not initialize iterator 'i', and that is
 correct logically because it is always initialized due to XYZ. Gcc does
 not realize this connection and emits a false warning. Annotate it with
 uninitialized_var().

 Signed-off-by: Steven Noonan <steven@uplinklabs.net>

Other good 'Impact:' tags are:

  Impact: fix boot crash
  Impact: style cleanup
  Impact: documentation fix

it's a "see impact at a glance" kind of thing. Maintainers will still 
read the rest and the code as well, but the thought process is much 
smoother: the maintainer can concentrate on "does what the patch does 
meet the expectation spelled out in the changelog", instead of spending 
time on "what does this patch do" thinking.

	Ingo
