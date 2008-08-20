Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYHTNuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYHTNuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYHTNt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:49:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYHTNtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:49:55 -0400
Date: Wed, 20 Aug 2008 15:48:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 05/10] ldisc: new dcd_change() method for line
	disciplines.
Message-ID: <20080820134849.GB20648@elte.hu>
References: <1219182612-13814-4-git-send-email-giometti@linux.it> <1219182612-13814-5-git-send-email-giometti@linux.it> <1219182612-13814-6-git-send-email-giometti@linux.it> <20080819225322.69f3215d@lxorguk.ukuu.org.uk> <20080819224930.GI21330@tekkaman> <20080819233857.41b756cc@lxorguk.ukuu.org.uk> <20080819230523.GJ21330@tekkaman> <20080820085303.GA17591@tekkaman> <20080820111117.0113da05@lxorguk.ukuu.org.uk> <20080820130124.GP21330@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820130124.GP21330@tekkaman>
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


* Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Wed, Aug 20, 2008 at 11:11:17AM +0100, Alan Cox wrote:
> 
> > Can we get the basics right first - drop the IRQ_EVENTS and HARDPPS
> > hackery out of the patchset and the core code then looks quite clean.
> > After that is sorted/merged we can come back to working out the best way
> > to improve the IRQ and HARDPPS hacks.
> 
> On Wed, Aug 20, 2008 at 12:31:15PM +0200, Ingo Molnar wrote:
> 
> > hm, NACK on this line of approach. If then this instrumentation should 
> > be done at the genirq level (kernel/irq/*.c). Also, the #ifdefs are ugly 
> > - please hide them in include files.
> 
> Ok, I'll propose a new patch set without the IRQ_EVENTS part (or with 
> this support as last patch to be easily discarted) to get kernel 
> inclusion, but we had to solve this issue soon since without this 
> trick the PPS precision is quite low.

well, i didnt suggest you kill that aspect of the patchset - i suggested 
you change it to hook into kernel/irq/*.c instead of 
arch/x86/kernel/irq*.c.

That way all other architectures will benefit from it, not just x86. 
Doing an x86-only thing for such features is completely unacceptable.

	Ingo
