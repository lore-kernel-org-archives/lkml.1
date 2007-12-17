Return-Path: <linux-kernel-owner+w=401wt.eu-S1759802AbXLQN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbXLQN25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXLQN2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:28:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54380 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbXLQN2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:28:49 -0500
Date: Mon, 17 Dec 2007 14:28:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix ref-counting bug in change_page_attr()
Message-ID: <20071217132802.GD1870@elte.hu>
References: <47610AB5.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47610AB5.76E4.0078.0@novell.com>
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

> When either calling change_page_attr() with the default attributes 
> pages in the direct mapping have and a page's attributes already were 
> set to the default or when changing the attributes from one 
> non-default value to another, the reference counting broke, leading to 
> either premature restoration of a large page or missing the 
> opportunity to do so.
> 
> At the same time, make __PHYSICAL_MASK_SHIFT on 64-bits the value it 
> architecturally ought to have.

hm, does this patch fix any real bug seen live? (if yes then do you have 
links to it, etc?) It would be a v2.6.24 fix in theory but it looks too 
dangerous for that. So i've queued it up for v2.6.25, for the time 
being.

	Ingo
