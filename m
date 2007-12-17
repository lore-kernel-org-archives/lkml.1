Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbXLQN0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbXLQN0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbXLQN0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:26:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34154 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbXLQN0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:26:39 -0500
Date: Mon, 17 Dec 2007 14:26:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64: make pda's cpunumber and nodenumber unsigned
Message-ID: <20071217132619.GB1870@elte.hu>
References: <47610530.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47610530.76E4.0078.0@novell.com>
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

> This generally allows better code to be generated, since the zero- 
> extension during 32-bit operations comes for free (needed when the 
> result is used as array index or similar), whereas sign extension must 
> be done explicitly and frequently requires a one byte larger 
> instruction due to the necessary rex64 prefix.

good catch! Applied your patch to x86.git - queued it up for v2.6.25. I 
bet there are tons of other instances where we use signed instead of 
unsigned and get worse code generation.

	Ingo
