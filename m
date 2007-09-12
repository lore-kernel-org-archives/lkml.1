Return-Path: <linux-kernel-owner+w=401wt.eu-S970434AbXILRGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970434AbXILRGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764335AbXILRG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:06:26 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:46367 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765236AbXILRGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:06:25 -0400
Subject: Re: Kernel Panic - 2.6.23-rc4-mm1 ia64 - was Re: Update: 
	[Automatic] NUMA replicated pagecache ...
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Joachim Deguara <joachim.deguara@amd.com>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Eric Whitney <eric.whitney@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070912154130.GS4835@shadowen.org>
References: <20070727084252.GA9347@wotan.suse.de>
	 <1186604723.5055.47.camel@localhost> <1186780099.5246.6.camel@localhost>
	 <20070813074351.GA15609@wotan.suse.de> <1189543962.5036.97.camel@localhost>
	 <46E74679.9020805@linux.vnet.ibm.com> <1189604927.5004.12.camel@localhost>
	 <46E7F2D8.3080003@linux.vnet.ibm.com> <1189609787.5004.33.camel@localhost>
	 <20070912154130.GS4835@shadowen.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 12 Sep 2007 13:04:14 -0400
Message-Id: <1189616655.5004.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 16:41 +0100, Andy Whitcroft wrote:
> On Wed, Sep 12, 2007 at 11:09:47AM -0400, Lee Schermerhorn wrote:
> 
> > > Interesting, I don't see a memory controller function in the stack
> > > trace, but I'll double check to see if I can find some silly race
> > > condition in there.
> > 
> > right.  I noticed that after I sent the mail.  
> > 
> > Also, config available at:
> > http://free.linux.hp.com/~lts/Temp/config-2.6.23-rc4-mm1-gwydyr-nomemcont
> 
> Be interested to know the outcome of any bisect you do.  Given its
> tripping in reclaim.

FYI:  doesn't seem to fail with 23-rc6.  

> 
> What size of box is this?  Wondering if we have anything big enough to
> test with.

This is a 16-cpu, 4-node, 32GB HP rx8620.  The test load that I'm
running is Dave Anderson's "usex" with a custom test script that runs:

5 built-in usex IO tests to a separate file system on a SCSI disk.
1 built-in usex IO rate test -- to/from same disk/fs.
1 POV ray tracing app--just because I had it :-)
1 script that does "find / -type f | xargs strings >/dev/null" to
pollute the page cache.
2 memtoy scripts to allocate various size anon segments--up to 20GB--
and mlock() them down to force reclaim.
1 32-way parallel kernel build
3 1GB random vm tests
3 1GB sequential vm tests
9 built-in usex "bin" tests--these run a series of programs
from /usr/bin to simulate users doing random things.  Not really random,
tho'.  Just walks a table of commands sequentially.

This load beats up on the system fairly heavily.

I can package up the usex input script and the other associated scripts
that it invokes, if you're interested.  Let me know...

Lee

