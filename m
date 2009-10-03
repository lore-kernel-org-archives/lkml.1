Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZJCKex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZJCKex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZJCKew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:34:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50498 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbZJCKew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:34:52 -0400
Date: Sat, 3 Oct 2009 12:34:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when building
	a kernel
Message-ID: <20091003103441.GA10874@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3791]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sam,

that arch-cache thing introduced in:

 5755433: kbuild: save ARCH & CROSS_COMPILE when building a kernel

isnt working very well in my experience.

1) it's a nuisance in cross-builds (it broke several cross-build scripts 
   of mine)

2) it makes it hard to switch from 32-bit x86 builds to 64-bit ones: 
   previously i only needed 'make ARCH=i386 defconfig' and off we went - 
   now i have to add a 'make mrproper' step.

3) it can also get stuck:

  phoenix:~/linux/linux> make mrproper
  Makefile:571: /home/mingo/tip/arch/no/Makefile: No such file or directory
  make: *** No rule to make target `/home/mingo/tip/arch/no/Makefile'.  Stop.

  phoenix:~/linux/linux> cat include/generated/*
  no

  phoenix:~/linux/linux> 

 There's no way out of this state, only if i manually remove 
 include/generated. (i suspect this is fixable)

Dunno - why isnt the .config enough in terms of determining which 
architecture we are on? If we want more info we should put it into the 
.config - not some other hidden state. I do think a single file should 
carry all 'configuration state' - that makes it easier to reproduce 
things, etc. etc. Everything else is really just hindering us.

	Ingo
