Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXLXXiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXLXXiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 18:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXLXXiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 18:38:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:60863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXLXXiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 18:38:06 -0500
Date: Mon, 24 Dec 2007 18:37:01 -0500
From: Theodore Tso <tytso@mit.edu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071224233701.GB9784@kernel.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Lameter <clameter@sgi.com>,
	Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org> <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2007 at 11:21:14AM -0800, Christoph Lameter wrote:
> 
> That is why there is a slabinfo tool that does all the nice formatting.
> 
> Do a
> 
> gcc -o slabinfo Documentation/vm/slabinfo.c 
> 
> Then run slabinfo instead of doing cat /proc/slabinfo

So two questions: why isn't -f the default?  And is /sys/slab
guaranteed to be a stable and permanent interface if the SLAB
implementation ever gets ripped out?  If so, maybe this should go into
util-linux-ng?  I am aa bit concerned about the lack of atomicity of
/sys/slab, but this is a heck of a lot better of many kernel drivers
or subsystems which use /sys and the completely punt on any kind of
userspace utility, forcing users to type crazy things like 

  echo 5 > /sys/bus/pci/drivers/iwl4965/*/power_level

						- Ted
