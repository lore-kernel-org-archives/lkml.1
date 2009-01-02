Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbZABSKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbZABSKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbZABSKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:10:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589AbZABSKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:10:12 -0500
Date: Fri, 2 Jan 2009 19:09:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Gautham R Shenoy <ego@in.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Sergio Luis <sergio@larces.uece.br>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: git-pull request for tip/cpus4096
Message-ID: <20090102180942.GB10072@elte.hu>
References: <495E4837.8090600@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495E4837.8090600@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> 
> Hi Ingo,
> 
> Here's the latest cpumask updates which includes the latest merge from 
> Rusty's cpumask tree.

Pulled into tip/cpus4096, thanks Mike.

Rusty already sent the pull request to Linus for his latest cpumask bits - 
is it fine if that goes upstream first and we do the second phase of the 
cpus4096 tree after that point?

Also, while testing tip/master i noticed that a couple of architectures 
wouldnt build due to cpumask changes:

   testing 21 architectures.
 
   testing       cris:  -git:  pass (  28),  -tip:  FAIL (  25)
   testing       m32r:  -git:  pass (  21),  -tip:  FAIL (  31)
 
both build failures go like this:
 
  /home/mingo/tip/lib/find_last_bit.c: In function 'find_last_bit':
  /home/mingo/tip/lib/find_last_bit.c:38: error: implicit declaration of function '__fls'
  make[2]: *** [lib/find_last_bit.o] Error 1
  make[2]: *** Waiting for unfinished jobs....
  make[1]: *** [lib] Error 2
 
these architectures have no __fls() implementation ...
 
trouble should be expected on ~8 architectures:
 
  for N in arch/*; do [ -d $N ] && ( printf "%-20s: " $N; cd $N; dgrep __fls |
    wc -l; ); done | sort -t: -n -k +2
 
 arch/cris           : 0
 arch/frv            : 0
 arch/h8300          : 0
 arch/m32r           : 0
 arch/m68k           : 0
 arch/mn10300        : 0
 arch/um             : 0
 arch/xtensa         : 0
 arch/arm            : 1
 arch/avr32          : 1
 arch/blackfin       : 1
 arch/ia64           : 1
 arch/m68knommu      : 1
 arch/parisc         : 1
 arch/powerpc        : 1
 arch/s390           : 1
 arch/sh             : 1
 arch/x86            : 1
 arch/alpha          : 2
 arch/sparc          : 2
 arch/mips           : 5
 
 	Ingo
