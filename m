Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbYAaUbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbYAaUbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYAaUbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:31:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54913 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbYAaUbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:31:46 -0500
Date: Thu, 31 Jan 2008 21:31:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: Why have __copy_from_user_ll_nocache* been exported?
Message-ID: <20080131203122.GA6457@elte.hu>
References: <20080131201430.GA9375@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131201430.GA9375@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> A commit that does nothing except for adding two unused 
> EXPORT_SYMBOL's.
> 
> Without any rationale why they should be exported.

the rationale is obvious: it's part of the standard uaccess 
functionality and while it's rarely used (in fact it's not used by any 
modular code right now) there's no reason not to export it alongside the 
other uaccess vectors. We can unexport it once we unexport all uses of 
the uaccess APIs. We could make it a _GPL export perhaps.

It's very annoying to driver writers when a small portion of a sensible 
API vector is not available symmetrically.

> And that from a person who on the other hand wants to introduce (and 
> tries to force on other people) deprecation periods for unused 
> EXPORT_SYMBOL's.

why does this bother you? The API makes total sense. This is a 
completely sensible API (with a full implementation) to use non-temporal 
copies. I mean, if this was some legacy API that nobody uses anymore i'd 
agree, but this is about the ability to access user-space memory via 
SSE2+ non-temporal stores.

	Ingo
