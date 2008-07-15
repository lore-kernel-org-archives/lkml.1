Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYGOHvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYGOHvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYGOHvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:51:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35261 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbYGOHvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:51:15 -0400
Date: Tue, 15 Jul 2008 09:50:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080715075049.GA16600@elte.hu>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <1216079223.27455.92.camel@shinybook.infradead.org> <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com> <1216081404.27455.97.camel@shinybook.infradead.org> <86802c440807141731m5286f640jfeaff1a73b923e7@mail.gmail.com> <1216083024.27455.123.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216083024.27455.123.camel@shinybook.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2008-07-14 at 17:31 -0700, Yinghai Lu wrote:
> > make[1]: *** No rule to make target
> > `include/config/builtin/firmware/dir.h', needed by
> > `firmware/ql2100_fw.bin.gen.S'.  Stop.
> > make: *** [firmware] Error 2
> 
> Oh, pants. Sorry, I renamed the CONFIG_BUILTIN_FIRMWARE option to 
> CONFIG_EXTRA_FIRMWARE some time back, but all my own test builds had 
> the include/config/builtin/firmware/dir.h file still lying around so I 
> didn't notice that I'd forgotten to change that manual dependency. And 
> evidently nobody using linux-next actually tried to include arbitrary 
> _other_ firmware into their tree. This patch should fix it...

here's another bugreport, i get this build failure with latest -git 
(which includes your fix above):

   CALL    scripts/checksyscalls.sh
   CHK     include/linux/compile.h
 make[1]: *** No rule to make target `firmware/tigon/tg3.bin', needed by `firmware/tigon/tg3.bin.gen.o'.  Stop.
 make: *** [firmware] Error 2

with:

  http://redhat.com/~mingo/misc/config-Tue_Jul_15_09_38_58_CEST_2008.bad

such configs worked before.

(i'd exclude TIGON3 from my qa builds but i've got tg3 hardware.)

	Ingo
