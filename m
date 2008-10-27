Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYJ0Knw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYJ0Knw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYJ0Knn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:43:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYJ0Knm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:43:42 -0400
Date: Mon, 27 Oct 2008 11:43:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, Jan Kara <jack@ucw.cz>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 2/2] ext4: fix a bug accessing freed memory in
	ext4_abort
Message-ID: <20081027104325.GA13641@elte.hu>
References: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com> <49056D29.2010700@hitachi.com> <49056FA5.7070202@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49056FA5.7070202@hitachi.com>
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


* Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> Vegard Nossum reported a bug which accesses freed memory.  When
> journal has been aborted, ext4_put_super() calls ext4_abort() after
> freeing the journal_t object, and then ext4_abort() accesses it.
> This patch fix it.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

could you please put the word "kmemcheck" into the commit log? ("found 
via kmemcheck" or so) We want to have an easily git-greppable track 
record of upstream kernel bugs that were found via kmemcheck. (and 
there's already a long list)

	Ingo
