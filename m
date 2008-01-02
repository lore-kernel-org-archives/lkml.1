Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbYABQTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYABQTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYABQTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:19:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbYABQTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:19:24 -0500
Date: Wed, 2 Jan 2008 17:18:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080102161846.GA2755@elte.hu>
References: <9DtBq-2jD-3@gated-at.bofh.it> <200801022131.15482.nickpiggin@yahoo.com.au> <1199271676.6821.112.camel@twins> <200801022212.29303.nickpiggin@yahoo.com.au> <1199273047.6821.119.camel@twins> <20080102121909.GA6285@elte.hu> <20080102132621.4da29e29@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102132621.4da29e29@the-village.bc.nu>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > BKL properties, that could be wrapped. I guess fixing the TTY code 
> > to have no BKL dependencies has a higher chance of success - given 
> > that Alan is working on it :-)
> 
> Bit by bit when I can face it, and with a lot of other people 
> contributing parts. Right now the BKL mostly protects the open/close 
> paths and those are *really* ugly

could we perhaps just replace it with a tty_mutex? (possibly a recursive 
one) I suspect by now most of the BKL dependencies there have become 
local to the tty code? Or are there deep VFS dependencies as well? (if 
yes, what type of dependencies?)

	Ingo
