Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXBSA20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXBSA20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 19:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbXBSA20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 19:28:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:58630 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbXBSA2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 19:28:25 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1171833885.3261.208.camel@laptopd505.fenrus.org>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <20070216124117.GB4218@elte.hu>
	 <1171833885.3261.208.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 11:25:53 +1100
Message-Id: <1171844753.5644.174.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 22:24 +0100, Arjan van de Ven wrote:
> On Fri, 2007-02-16 at 13:41 +0100, Ingo Molnar wrote:
> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> > 
> > > So I propose we remove all assumptions from the code that we actually 
> > > have an array of irqs.  That will allow for irq_desc to be dynamically 
> > > allocated instead of statically allocated saving memory and reducing 
> > > kernel complexity.
> > 
> > hm. I'd suggest to do this without changing request_irq() - and then we 
> > could avoid the 'massive, every driver affected' change, right?
> 
> if request_irq() changes we might as well make a variant that takes a
> PCI device struct rather than a number, for the 99% of PCI drivers that
> use that.. (and then msi and other stuff becomes simpler :)

As a matter of fact, if IRQs has to be handled properly as resources of
their respective devices, I think request_irq replacement should take a
struct device...

In fact, having IRQs hanging off their respective devices would give a
proper way to access them via sysfs and implement the affinity etc...
thus providing a long term replacement for the current number based
APIs.

In addition, to facilitate the job of things like IRQ balancing daemons,
a /sys/irqs/ could be created containing symlinks to all irqs in the
system.

Ben.
 

