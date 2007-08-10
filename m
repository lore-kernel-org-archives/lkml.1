Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbXHJHk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbXHJHk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXHJHkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:40:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35989 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbXHJHkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:40:08 -0400
Date: Fri, 10 Aug 2007 09:40:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, josh@freedesktop.org,
       linux-kernel@vger.kernel.org, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: 2.6.23-rc2-mm1: sleeping function called from invalid context
	at kernel/mutex.c:86
Message-ID: <20070810074000.GA28264@elte.hu>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <200708100123.07762.m.kozlowski@tuxland.pl> <20070809171128.03f40dff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809171128.03f40dff.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> We seem to have made a mess in there.  timer_list_show() ends up 
> calling lookup_module_symbol_name(), which takes a mutex.  However 
> print_symbol() (which is called at oops time, interrupt time, etc) 
> calls module_address_lookup(), which is basically the same, only it 
> doesn't take the mutex.

hm, current upstream does:

 static void print_name_offset(struct seq_file *m, void *sym)
 {
         char symname[KSYM_NAME_LEN];

         if (lookup_symbol_name((unsigned long)sym, symname) < 0)

why was that changed? I think symbol lookups for debug purposes have to 
be lockless, fundamentally.

	Ingo
