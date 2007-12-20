Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbXLTVjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbXLTVjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXLTVji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:39:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43992 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbXLTVji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:39:38 -0500
Date: Thu, 20 Dec 2007 22:39:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
Message-ID: <20071220213906.GB11897@elte.hu>
References: <20071219223534.129042140@goop.org> <20071220094940.GA14227@elte.hu> <20071220112022.GA15832@elte.hu> <476AD9EA.7010108@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AD9EA.7010108@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > found a couple of bugs.
> >
> > firstly, 64-bit wasnt so lucky, you broke 
> > iounmap()/change_page_attr()
> > :-)
> 
> Crap.  Worked for me.  I'll look into it.

well, there's an easy solution for unification patches: the resulting 
object files must have _exactly the same_ content as without the 
unification patches. (Modulo strings as WARN_ON()s referring to 
include-file names.)

If they differ then the unification did something wrong. With your 
patchset and the config i sent, the difference is visible in the image 
size already:

   text     data   bss     dec              hex    filename
   7763766  967330 5812328 14543424         ddea40 vmlinux.after
   7763811  967330 5812328 14543469         ddea6d vmlinux.before

also, reducing the size and scope of changes helps as well - because 
that way it can be bisected down to specific changes. Mistakes 
inevitably happen, especially if you do not enforce a rigid 
byte-for-byte correctness along the way. You did 5 rather large patches, 
and it's not testable because your unification steps were too coarse.

In other words: you were asking for trouble and you got it :-)

	Ingo
