Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYJ3Uiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYJ3Uiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYJ3Uir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:38:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbYJ3Uiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:38:46 -0400
Date: Thu, 30 Oct 2008 21:38:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 1/2] ftrace: nmi safe code modification
Message-ID: <20081030203810.GM27407@elte.hu>
References: <20081030200831.467420488@goodmis.org> <20081030201127.820600693@goodmis.org> <20081030133228.824e3f69.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030133228.824e3f69.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	/* make sure NMIs see the cleared bit */
> > +	smp_mb();
> > +
> > +	wait_for_nmi();
> > +
> > +	return mod_code_status;
> > +}
> 
> I guess the weakness here is that the code will only allow a single 
> contiguous hunk of text to be modified.  One could envisage 
> situations where two or more separate areas of memory need to be 
> modified atomically/together.
> 
> I guess we can cross that bridge when we fall off it.

yeah - the whole 'transaction' concept can be extended easily, in just 
one place.

Not that i think that it would really be useful to go beyond the 
current (target,len) abstraction - the less complex code patching is 
done, the better.

	Ingo
