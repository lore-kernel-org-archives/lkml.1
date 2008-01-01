Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYAAMxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYAAMxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 07:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYAAMxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 07:53:34 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38629 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbYAAMxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 07:53:33 -0500
Date: Tue, 1 Jan 2008 07:47:41 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20080101124741.GH11776@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Christoph Lameter <clameter@sgi.com>, Willy Tarreau <w@1wt.eu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <20071225033418.GA29199@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071225033418.GA29199@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2007 at 04:34:18AM +0100, Andi Kleen wrote:
> > And is /sys/slab
> > guaranteed to be a stable and permanent interface if the SLAB
> 
> Debugging feature and "stable and permanent" just don't 
> fit together. It's like requesting stable and permanent
> sysrq output.

Yeah, unfortunately, querying to find out how much memory is being
used by which parts of the system is something which I think needs to
be more than just a debugging feature.  One could argue that "vmstat",
"iostat", and "sar" are debugging features as well, but other people
would consider them "critical programs to get information necessary to
monitor the health of their system".

Perhaps /proc/slabinfo should be that relatively stable interface, if
/sys/slab can't be guaranteed to be stable.  But there *are* people
who will want to monitor information like this on an ongoing fashion
on production systems.  One of the major downsides of /sys seems to be
that it's very hard to keep it stable, so maybe it's not the right
tool for this.  /proc/slabinfo has the advantage that it's a simple
text file, and its format is relatively well-understood, and doesn't a
patch to provide /proc/slabinfo for SLUB already exist?

							- Ted
