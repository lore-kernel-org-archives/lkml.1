Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYIHOd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYIHOd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYIHOdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:33:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbYIHOds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:33:48 -0400
Date: Mon, 8 Sep 2008 16:33:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] x86: io-apic - convert DO_ACTION macro into function
Message-ID: <20080908143335.GD10580@elte.hu>
References: <20080907192625.GC7515@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080907192625.GC7515@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Convert DO_ACTION macro into more obvious io_apic_modify_irq
> function with callers
> ---
> 
>  I found it more readable then original was. Especialy we could grep 
> the callers in normal way. It's just an attempt - free to drop this 
> patch. I hope I don't messed with all these masks :) So the question 
> is rather NOT about details but idea in general.

yeah - getting rid of such macros is a very good idea in general.

>  io_apic.c |  102 ++++++++++++++++++++++++++++++--------------------------------
>  1 file changed, 50 insertions(+), 52 deletions(-)

that's non-trivial impact. Did the .o md5sum survive this transformation 
just fine? (in theory gcc should generate the same code - but it doesnt 
always do that across macro->inline function changes, so it's hard to 
validate these kinds of changes.)

	Ingo
