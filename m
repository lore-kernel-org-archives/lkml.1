Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZAEOfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZAEOfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZAEOfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:35:38 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:36610 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbZAEOfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:35:36 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1231093310.27690.5.camel@twins>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <1231093310.27690.5.camel@twins>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 09:34:23 -0500
Message-Id: <1231166063.4290.37.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49621A75.0062:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 19:21 +0100, Peter Zijlstra wrote:
> On Sat, 2009-01-03 at 12:17 -0700, Matthew Wilcox wrote:
> > > - locking.c needs a lot of cleanup.
> > > If combination spinlocks/mutexes are really a win they should be 
> > > in the generic mutex framework. And I'm still dubious on the
> > hardcoded 
> > > numbers.
> > 
> > I don't think this needs to be cleaned up before merge.  I've spent
> > an hour or two looking at it, and while we can do a somewhat better
> > job as part of the generic mutex framework, it's quite tricky (due to
> > the different <asm/mutex.h> implementations).  It has the potential to
> > introduce some hard-to-hit bugs in the generic mutexes, and there's some
> > API discussions to have.
> 
> I'm really opposed to having this in some filesystem. Please remove it
> before merging it.
> 

It is 5 lines in a single function that is local to btrfs.  I'll be
happy to take it out when a clear path to a replacement is in.

I know people have been doing work in this area for -rt, and do not want
to start a parallel effort to change things.

I'm not trying to jump into the design discussions because there are
people already working on it who know the issues much better than I do. 

But, if anyone working on adaptive mutexes is looking for a coder,
tester, use case, or benchmark for their locking scheme, my hand is up.

Until then, this is my for loop, there are many like it, but this one is
mine.

-chris


