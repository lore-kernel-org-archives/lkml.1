Return-Path: <linux-kernel-owner+w=401wt.eu-S1761054AbYDDNAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054AbYDDNAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760347AbYDDM4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:56:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760069AbYDDM4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:56:19 -0400
Date: Fri, 4 Apr 2008 14:55:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: additional fix for making ioremap() accept
	64-bit addresses
Message-ID: <20080404125543.GA29423@elte.hu>
References: <47F638FD.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F638FD.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> The recent change to __ioremap()'s first parameter's type didn't yield 
> the intended effect as the first conditional inside the function would 
> still have filtered out any addresses with bits [63:32] set. Correct 
> last_addr's type and at once also add a check that the address range 
> doesn't extend into space hardware cannot support even theoretically.

i fixed this in x86.git more than a week ago, see:

|  Subject: x86: ioremap of 64-bit resource on 32-bit kernel fix
|  From: Ingo Molnar <mingo@elte.hu>
|  Date: Tue, 25 Mar 2008 08:31:17 +0100

but since 64-bit resources never worked on 32-bit and the initiator 
regression causing this discussion turned out to be something else, i 
delayed this fix as .26 material.

the PHYSICAL_MASK fix looks good as an additional check - could you 
please resend it against x86.git/latest which has my fix already?

	Ingo
