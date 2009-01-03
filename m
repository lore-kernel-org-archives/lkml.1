Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbZACKwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbZACKwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZACKwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:52:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53912 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZACKwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:52:24 -0500
Date: Sat, 3 Jan 2009 11:52:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
Message-ID: <20090103105208.GA19080@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901031751.00076.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Saturday 03 January 2009 07:08:40 Ingo Molnar wrote:
> >  - architectures that have no __fls (8 out of 21) fail to build:
> > 
> >      arch/cris
> >      arch/frv
> >      arch/h8300
> >      arch/m32r
> >      arch/m68k
> >      arch/mn10300
> >      arch/xtensa
> 
> Fixes pushed, m68k should be OK tho; is this actual compile test?  You have
> to look in include/asm-m68k to see __fls.

yeah, i stopped the tests after the first two build failures - the rest is 
a grep result from arch/*/, that's why include/asm-m68k/ was left out.

> > Rusty, would it be fine with you if we did all the remaining bits via 
> > tip/cpus4096? It's your tree and your bits and we wanted to send our 
> > remaining bits after your tree went to Linus but the conflict 
> > resolutions from Mike are valuable so i think we should reconsider the 
> > ordering.
> 
> Yeah, no reason for us to do the merge twice.  As long as it ends 
> upstream, I'm a happy camper.

great - lets do it that way then. I have pulled your fixes into the 
cpus4096 tree:

 5ece5c5: xtensa: define __fls
 5c134da: mn10300: define __fls
 16a2062: m32r: define __fls
 9ddabc2: h8300: define __fls
 ee38e51: frv: define __fls
 0999769: cris: define __fls

Once we have figured out the CPU-hotplug lockdep splat (possibly due to 
Mike's changes not yours) i'll send it to Linus. Thanks,

	Ingo
