Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbYD3SKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbYD3SKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYD3SKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:10:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbYD3SKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:10:43 -0400
Date: Wed, 30 Apr 2008 20:10:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@queued.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: ioremap ram check fix
Message-ID: <20080430181015.GB31726@elte.hu>
References: <20080430113024.43aa3935@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430113024.43aa3935@ephemeral>
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


* Andres Salomon <dilinger@queued.net> wrote:

> Hi Ingo,
> 
> bdd3cee2e4b7279457139058615ced6c2b41e7de (x86: ioremap(), extend check 
> to all RAM pages) breaks OLPC's ioremap call.  The ioremap that OLPC 
> uses is:

that breakage has been reported independently as well and the revert has 
been pushed to Linus yesterday - it's not upstream yet. See this commit 
in x86.git:

 commit 1b8104a0ec138de829bb351f6597d534c7c134dc
 Author: Ingo Molnar <mingo@elte.hu>
 Date:   Tue Apr 29 12:04:51 2008 +0200

    revert: "x86: ioremap(), extend check to all RAM pages"

    Vegard Nossum reported a large (150 seconds) boot delay during bootup,
    and bisected it to "x86: ioremap(), extend check to all RAM pages"
    (commit bdd3cee2e4b). Revert this commit for now.

    Bisected-by: Vegard Nossum <vegard.nossum@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

	Ingo
