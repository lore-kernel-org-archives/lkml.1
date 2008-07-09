Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYGIUI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYGIUI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYGIUIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:08:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYGIUIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:08:17 -0400
Date: Wed, 9 Jul 2008 22:07:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709200757.GD14009@elte.hu>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1abgqzv3g.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> I just took a quick look at how stack_protector works on x86_64.  
> Unless there is some deep kernel magic that changes the segment 
> register to %gs from the ABI specified %fs CC_STACKPROTECTOR is 
> totally broken on x86_64.  We access our pda through %gs.
> 
> Further -fstack-protector-all only seems to detect against buffer 
> overflows and thus corruption of the stack.  Not stack overflows.  So 
> it doesn't appear especially useful.

CC_STACKPROTECTOR, as fixed in -tip, can catch the splice exploit, and 
there's no known breakage in it.

Deep stack recursion itself is not really interesting. (as that cannot 
arbitrarily be triggered by attackers in most cases) Random overflows of 
buffers on the stackframe is a lot more common, and that's what 
stackprotector protects against.

( Note that deep stack recursion can be caught via another debug
  mechanism, ftrace's mcount approach. )

> So we don't we kill the broken CONFIG_CC_STACKPROTECTOR.  Stop trying 
> to figure out how to use a zero based percpu area.

Note that the zero-based percpu problems are completely unrelated to 
stackprotector. I was able to hit them with a stackprotector-disabled 
gcc-4.2.3 environment.

	Ingo
