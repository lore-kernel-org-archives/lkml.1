Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZGBPa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZGBPa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbZGBPal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:30:41 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3405 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbZGBPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:30:35 -0400
Subject: Re: printk regression?
From: Joe Perches <joe@perches.com>
To: lkml@morethan.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200907020729.23976.lkml@morethan.org>
References: <4A4C3410.8080704@kernel.org>
	 <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
	 <1246513356.28915.62.camel@Joe-Laptop.home>
	 <200907020729.23976.lkml@morethan.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:29:16 -0700
Message-Id: <1246548556.28915.80.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 07:29 -0500, Michael S. Zick wrote:
> On Thu July 2 2009, Joe Perches wrote:
> > On Wed, 2009-07-01 at 21:23 -0700, Linus Torvalds wrote:
> > > On Wed, 1 Jul 2009, Yinghai Lu wrote:
> > > > [   75.690022] <7>printing local APIC contents on CPU#0/0:
> > > Yes. This is because the io_apic code should be fixed.
> > > It does:
> > > 	printk("\n" KERN_DEBUG "printing local APIC
> > > and that "\n" at the beginning should just be deleted. The log-level 
> > > should be at the beginning of the printk, not in the middle.
> > There's at least 72 of them:
> > $ grep -Pr --include=*.[ch] "\bprintk.*\\\n.*KERN_" *
> That should qualify it as a documented feature.  ;)
> "To convert the log level marker into visible garbage, do..."

Before some changes to the printk code, that used to
be the only way to get a single printk call with multiple
line output to have a KERN_<level> on all output lines.

ie:	printk(KERN_INFO "Line 1\n" KERN_INFO "Line 2\n");

That style doesn't show up in the grep I posted because most
of them look like:

	printk(KERN_INFO "Line 1\n"
	       KERN_INFO "Line 2\n");

An example:  here's a bit of kernel/module.c:

		printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d, "
				    "it should follow 0/-E convention\n"
		       KERN_WARNING "%s: loading module anyway...\n",



