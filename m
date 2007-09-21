Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbXIUGdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbXIUGdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 02:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXIUGdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 02:33:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38411 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXIUGdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 02:33:43 -0400
Date: Thu, 20 Sep 2007 23:33:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@infradead.org>,
       David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Test harness in the kernel for new syscalls? [Was: Trace code
 and documentation (updated)]
Message-Id: <20070920233317.edb29d58.randy.dunlap@oracle.com>
In-Reply-To: <20070920215042.38fd3546.randy.dunlap@oracle.com>
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com>
	<p736427vz00.fsf@bingen.suse.de>
	<46F12ED7.3060605@us.ibm.com>
	<20070919162018.GA16237@infradead.org>
	<20070919095223.83bd8226.randy.dunlap@oracle.com>
	<20070919165507.GA18973@infradead.org>
	<20070919174845.GD3115@uranus.ravnborg.org>
	<20070919175109.GA23889@infradead.org>
	<20070919180115.GE3115@uranus.ravnborg.org>
	<20070920215042.38fd3546.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 21:50:42 -0700 Randy Dunlap wrote:

> On Wed, 19 Sep 2007 20:01:15 +0200 Sam Ravnborg wrote:
> 
> > On Wed, Sep 19, 2007 at 06:51:09PM +0100, Christoph Hellwig wrote:
> > > On Wed, Sep 19, 2007 at 07:48:45PM +0200, Sam Ravnborg wrote:
> > > > > Well, this is kernel code - so util-linux is not the solution here
> > > > > obviously :)
> 
> so kernel sample code goes in the new samples/ directory,
> and userspace sample code gets pushed to util-linux ?
> 
> > > > Can you sketch what you have in mind.
> > > > We right now have said we wnated to:
> > > > 1) include a framework for executing simple new-syscall-test-stubs
> > > > 2) have a nice place for kernel example code
> > > > 
> > > > I could come up with something but I expect you already have something
> > > > in your mind where to put stuff.
> > > > If I have a rough idea I can start looking into the kbuild bits of it.
> > > > Not that I will have it ready within the next two weeks but nice buffer
> > > > when I anyway drop sleeping..
> > > 
> > > I think for samples we just want a samples/ toplevel directory with
> > > normal Kbuild and Kconfig files.  Not any different from drivers or
> > > filesystems, just a new hiearchary.
> > 
> > OK - anyone can do this. So I will not worry.


I began looking into this.

Yes, we should add Makefile(s) so that sample code can be built.
Does that mean that it has to be moved to a different directory?

For some (not all) sample code, we either move its related txt or
README file to the samples/ dir also, or we create the need to
look in 2 places to see the sample code + related doc.

The latter is not good, so I suppose that we move those related
txt files with the sample code.  Then we have docs split into
2 places (not counting drivers/ and fs/ .txt files & other README*
files throughout the kernel tree).  Having docs split into more
places isn't good either.

I'm for just add Makefile(s) in the Documentation/ tree so that
sample code can be built there (as well as moving the sample
code out of .txt files and into standalone source files).


I'll back up and re-read where this (new) requirement is coming
from.

[reads]

It seems to mostly be about having the ability to build the sample
code so that it doesn't bitrot.  That's good.  But docs and sample
code are often very related.  I don't see why we would arbitrarily
split them up.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
