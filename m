Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXDDVrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXDDVrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXDDVrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:47:17 -0400
Received: from www.osadl.org ([213.239.205.134]:36119 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752159AbXDDVrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:47:14 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       johnstul@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
In-Reply-To: <20070404134812.0c23c5af.akpm@linux-foundation.org>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	 <1175417035.28263.42.camel@localhost.localdomain>
	 <1175704712.15973.35.camel@imap.mvista.com>
	 <20070404125853.1cf9b7b7.akpm@linux-foundation.org>
	 <1175717425.15973.61.camel@imap.mvista.com>
	 <20070404203647.GA12563@elte.hu>
	 <20070404134812.0c23c5af.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 23:47:31 +0200
Message-Id: <1175723252.28263.359.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 13:48 -0700, Andrew Morton wrote:
> On Wed, 4 Apr 2007 22:36:47 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > The struct clocksource .list field is now required to be initialized 
> > > before calling clocksource_register().
> > > 
> > > This is a prerequisite for simplifying the clocksource registration 
> > > process.
> > 
> > why?
> 
> It's all enablement for
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/broken-out/clocksource-refactor-duplicate-registration-checking.patch,
> on which I have no opinion.

I have. Just noticed that my original comment got stuck in mail jam:

> Refactors the duplicate registration checking. This makes it based on the
> clocksource structure list state. I was able to drop some if statements
> making the registration code path slightly smaller and faster, and remove
> some looping which was endemic of the first version of this check.

What does the slightly smaller and faster buy us ? 

Which looping has been removed ? If you want to optimize this code then
you need to break out of the loop, once the rating check has found the
place to stick it in.

But I still do not see any advantage in this. Registration is a one time
operation and not near any fast path. 

	tglx


