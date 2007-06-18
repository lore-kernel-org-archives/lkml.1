Return-Path: <linux-kernel-owner+w=401wt.eu-S1763332AbXFRNLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763332AbXFRNLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbXFRNLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:11:36 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:36271 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761652AbXFRNLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:11:35 -0400
To: mingo@elte.hu
CC: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, kiran@scalex86.org
In-reply-to: <20070618123646.GA22672@elte.hu> (message from Ingo Molnar on
	Mon, 18 Jun 2007 14:36:46 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu> <20070618083109.GA23572@elte.hu> <E1I0ChN-0006nd-00@dorka.pomaz.szeredi.hu> <20070618091832.GA1860@elte.hu> <20070618093848.GA6880@elte.hu> <20070618094414.GA8261@elte.hu> <E1I0EJc-0007El-00@dorka.pomaz.szeredi.hu> <20070618123646.GA22672@elte.hu>
Message-Id: <E1I0Gzz-0007iA-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 15:10:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > how about the patch below? Boot-tested on 32-bit. As a side-effect 
> > > > this change also removes the 255 CPUs limit from the 32-bit kernel.
> > > 
> > > boot-tested on 64-bit too now.
> > 
> > Strange, I can't even get past the compile stage ;)
> > 
> >   CC      kernel/spinlock.o
> > {standard input}: Assembler messages:
> > {standard input}:207: Error: backward ref to unknown label "4:"
> 
> oh, sorry - i built it with !PREEMPT, which doesnt make use of the flags 
> thing. I fixed the build and have cleaned up and simplified that code 
> some more - does the patch below work for you? (it does for me on both 
> 32-bit and 64-bit)

Thanks.  The patch boots, and...  doesn't solve the bug.  Weird.

CPU bug?  I've upgraded the BIOS not such a long time ago.

I guess now we know what the problem is, it would be pretty easy to
create some test code, that uses two threads, one of which loops in
lock/unlock/rep_nop and the other that tries to acquire the lock and
measures latency.

Should I try to do that?

Thanks,
Miklos
