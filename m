Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbXL3O5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbXL3O5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbXL3O5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:57:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50650 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbXL3O5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:57:47 -0500
Date: Sun, 30 Dec 2007 15:53:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: tglx@linutronix.de, Maxim <maximlevitsky@gmail.com>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
Message-ID: <20071230145304.GS16946@elte.hu>
References: <200703161230.03712.maximlevitsky@gmail.com> <200703161919.44458.lenb@kernel.org> <200703180100.01889.maximlevitsky@gmail.com> <1174174374.13341.448.camel@localhost.localdomain> <1199001010.5452.30.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199001010.5452.30.camel@homer.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> > Is this after resume ? If yes, then something (probably BIOS) is 
> > fiddling with the TSC of one CPU when the resume happens.
> 
> My P4 box has the same "problem", which is remedied by..

> -	start = get_cycles_sync();
> +	start = last_tsc = get_cycles_sync();

this is slightly racy - your second patch that initializes things 
properly is the right solution IMO. I'm wondering, if others are seeing 
this too, should we make this a v2.6.24 item? It's a bit late for that i 
think - although it shouldnt hurt.

	Ingo
