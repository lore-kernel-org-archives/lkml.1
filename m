Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbXBNWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbXBNWKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964804AbXBNWKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:10:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36186 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805AbXBNWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:10:37 -0500
Subject: Re: [patch] x86: split FPU state from task state
From: Arjan van de Ven <arjan@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ingo Molnar <mingo@elte.hu>, Davide Libenzi <davidel@xmailserver.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070214220443.GN32271@kvack.org>
References: <20070214103655.GB4241@flint.arm.linux.org.uk>
	 <20070214105039.GC6801@elte.hu>
	 <20070214110419.GC4241@flint.arm.linux.org.uk>
	 <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
	 <20070214180344.GI32271@kvack.org>
	 <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com>
	 <20070214200347.GK32271@kvack.org>
	 <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com>
	 <20070214203438.GL32271@kvack.org> <20070214214944.GA1082@elte.hu>
	 <20070214220443.GN32271@kvack.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 14 Feb 2007 23:10:17 +0100
Message-Id: <1171491017.12771.483.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 17:04 -0500, Benjamin LaHaise wrote:
> On Wed, Feb 14, 2007 at 10:49:44PM +0100, Ingo Molnar wrote:
> > this can very much be done, with a straightforward extension of how we 
> > handle FPU state. That makes sense independently of syslets/async as 
> > well, so find below the standalone patch from Arjan. It's in my current 
> > syslet queue and works great.
> 
> That patch adds a bunch of memory dereferences 

not really; you missed that most of the ->'s are actually just going to
members of the union and aren't actually extra dereference.

> and another allocation 
> to the thread creation code path -- a tax that all users must pay. 

so the next step, as mentioned in the changelog, to allocate only on the
first FPU fault, so that it becomes a GAIN for everyone, since only
threads that use FPU will use the memory.

The second gain (although only on old cpus) is that you only need to
allocate enough memory for your cpu, rather than 512 always.



-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

