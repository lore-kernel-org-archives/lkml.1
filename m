Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZEKOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZEKOQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZEKOQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:16:12 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50556 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbZEKOQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:16:11 -0400
X-Sasl-enc: i//5Vl9Tl9bImDwxPEmw0ErwbFFSKrChoy90VRVNs1eN 1242051370
Date: Mon, 11 May 2009 15:15:57 +0100
From: Jack Stone <jwjstone@fastmail.fm>
To: Christoph Hellwig <hch@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Regression testing framework for the kernel
Message-ID: <20090511141557.GA8677@localhost>
References: <1241125556.12894.1313160577@webmail.messagingengine.com> <20090511094412.GA3665@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511094412.GA3665@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 05:44:12AM -0400, Christoph Hellwig wrote:
> On Thu, Apr 30, 2009 at 11:05:56PM +0200, Jack Stone wrote:
> > Hi All,
> > 
> > I would like to suggest a new framework to test the kernel. This
> > framework would have the following goals:
> >     * Only runs at build time and has no effect on running kernel
> 
> I don't think we should ever run tests at build time unconditionally.
> If we want to integrate it with make it should at least be a separate
> make check.

Sorry I should have said explicitly, that was my intention.

> > The best way of acheiving this that I have thought of it to compile the
> > kernel source in question and
> > to link it with special framework files. These files would serve two
> > purposes: to provide the main function
> > of the program and to provide the missing symbols for the kernel code.
> > This would allow the replacement of
> > certain functions in the code. For example replacing the spin_lock and
> > spin_unlock functions would allow the
> > locking behavior to be checked.
> 
> That's going to be a lot of stubs if we want to have a wide coverage.
> Then again people are alredy doing this in various places, either with
> the code in-tree but not easily buildable or out of tree, so having
> all this in a common place and a common test driver would be a defintive
> improvement.  The right approach would probably be to add stubs on a
> as-needed basis instead of trying to provide full coverage.

I agree. It would be too error prone to add it as 1 huge patch. Taking
bite sized chunks would be better, as long as they are all functional.
 
> > Usage examples:
> >     * Test the behavior of a device driver
> >          As various kernel functions can be overridden a test case could
> >          be written to simulate a given device and
> >          check that there are no regressions in the driver
> 
> Not sure that is a good use.  If we want to emulate hardware I think
> we're better of using qemu for it and run a normal kernel under it.

Agreed.

> >     * Regression testing
> >          Any time a regression is found and fixed in the kernel a test
> >          case could be written to check that the
> >          regression does not reoccur later on.
> 
> I think that is the primary use case. Regresion-tests for library-ish
> code that doesn't require much global state.

I think that would be a good starting point, but I would like to extend
the testing to as much of the kernel as possible over time. I know it's
difficult because of the global state but in theory it should be
possible.

Thanks,

Jack 
