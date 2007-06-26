Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXFZQTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXFZQTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbXFZQTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:19:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXFZQTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:19:45 -0400
Date: Tue, 26 Jun 2007 18:18:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-ID: <20070626161857.GA7178@elte.hu>
References: <20070625200601.GA18980@elte.hu> <200706252309.47467.zippel@linux-m68k.org> <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com> <Pine.LNX.4.64.0706252356400.1817@scrub.home> <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesper Juhl <jesper.juhl@gmail.com> wrote:

> > Ingo provided no information about his test setup and his patch was 
> > a little strange, so I can't say that yet.
>
> What did you find strange about it? I'm currious. Sure it needs 
> testing and of course it would be nice with some more details on 
> Ingo's test setup.

My patch improves MySQL wall-clock performance by ~10% on a dual-core 
box [see the numbers i cited in my initial mail, they were ran on a T60 
with a 1.83 GHz Core2Duo] and by 7% on an 8-way box:

 2.6.22-rc6:

 #threads
  9:     transactions:                        8440   (843.29 per sec.)
  9:     transactions:                        8423   (841.18 per sec.)
  9:     transactions:                        8511   (849.98 per sec.)
  9:     transactions:                        8473   (846.23 per sec.)

 2.6.22-rc6 + sys_time.patch:

 #threads
  9:     transactions:                        9043   (903.36 per sec.)
  9:     transactions:                        9020   (900.78 per sec.)
  9:     transactions:                        8974   (896.61 per sec.)
  9:     transactions:                        9007   (899.97 per sec.)

[ to reproduce it, run sysbench 0.4.8 with --test=oltp --num-threads=9. 
  The other tests show similar speedup, so this is in no way limited to 
  OLTP. ]

in other words, if you are using MySQL in a serious way then this patch 
provides you a real-world speedup equivalent to upgrading a 1.66 GHz 
Core2Duo to a 1.83 GHz Core2Duo. I'd call that anything but "slightly 
improved performance" ;-)

if you are curious why Roman's reaction to this patch was so negative: 
i'm extremely curious myself too! ;-) That man, with his eternal 
negativism (i dare anyone to point me to a _single_ lkml posting of 
Roman where he gives any positive feedback to anyone) is a pure walking 
mystery to me ;)

( whether there is any correlation between a decade long fundamental
  suckage and stagnation of the Linux time and NTP subsystem and Roman's
  decade long negative feedback presence in that area of code is left up
  to the reader. :)

This current ... interesting piece of Roman about a _single_ trivial 
unlikely() branch in do_gettimeofday() borders on the ridiculous. My 
patch might be wrong for various reasons, but that single
'if (unlikely())' statement is not one of those reasons =B-)

	Ingo
