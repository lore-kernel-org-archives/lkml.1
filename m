Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbZJLTTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbZJLTTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbZJLTTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:19:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933044AbZJLTTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:19:32 -0400
Date: Mon, 12 Oct 2009 21:18:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012191824.GL17138@elte.hu>
References: <20091012120951.GA16799@elte.hu> <20091012142714.56362465@marrow.netinsight.se> <20091012123210.GB22766@elte.hu> <20091012140821.5dfa1598@lxorguk.ukuu.org.uk> <20091012132503.GD25464@elte.hu> <1255354342.30919.17.camel@macbook.infradead.org> <20091012142634.GB4565@elte.hu> <1255358181.9111.14.camel@macbook.infradead.org> <20091012151431.GC14004@elte.hu> <4AD3763C.70307@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD3763C.70307@gmx.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net> wrote:

> > I wish it worked on any of the 10+ x86 systems i have. Is there 
> > anyone who'd be interested in exploring whether warm BIOS reboots 
> > work _anywhere_?
> 
> AFAIK memory clearing is default off in coreboot for non-ECC RAM and 
> default on for ECC RAM (to avoid parity errors on read, but that can 
> probably be worked around). Unless I'm mistaken, the SeaBIOS BIOS 
> compatibility layer on top of coreboot doesn't erase RAM at all, so 
> contents can survive.
>
> No idea about classic AMI/Award/Phoenix/Insyde/whatever BIOS, though.

I wouldnt mind to support this for coreboot too, but it will only be 
practical if there's at least one standard BIOS out of the many i run 
that supports warm reboot in practice ...

Can try a test-patch on all of those systems btw. - we do support 
warm-reboot on x86 in arch/x86/kernel/reboot.c:

        /* Write 0x1234 to absolute memory location 0x472.  The BIOS reads
           this on booting to tell it to "Bypass memory test (also warm
           boot)".  This seems like a fairly standard thing that gets set by
           REBOOT.COM programs, and the previous reset routine did this
           too. */
        *((unsigned short *)0x472) = reboot_mode;

But someone would have to come up with a test-patch to prove whether it 
works really works.

	Ingo
