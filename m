Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZAEEUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZAEEUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 23:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZAEEUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 23:20:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:51316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbZAEEUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 23:20:03 -0500
Date: Mon, 5 Jan 2009 05:19:59 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Klotz <peter.klotz@aon.at>, Roman Kononov <kernel@kononov.ftml.net>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20090105041959.GC367@wotan.suse.de>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org> <20081230042333.GC27679@wotan.suse.de> <20090103214443.GA6612@infradead.org> <20090105014821.GA367@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105014821.GA367@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 02:48:21AM +0100, Nick Piggin wrote:
> On Sat, Jan 03, 2009 at 04:44:43PM -0500, Christoph Hellwig wrote:
> > On Tue, Dec 30, 2008 at 05:23:33AM +0100, Nick Piggin wrote:
> > > On Tue, Dec 23, 2008 at 12:12:59PM -0500, Christoph Hellwig wrote:
> > > > 
> > > > Nick, I've seen various reports like this by Roman.  It seems to be
> > > > caused by an interaction of the lockless pagecache with the xfs
> > > > I/O code.  Any idea what might be wrong here:
> > > 
> > > Hmm, it could get into a loop here if there is a page in the pagecache
> > > with a zero refcount, which might be a problem with XFS... other looping
> > > conditions might indicate a problem iwth lockless pagecache or radix
> > > tree. It would be very helpful to know what condition it is looping on...
> > 
> > See http://oss.sgi.com/bugzilla/show_bug.cgi?id=805
> 
> OK.. Hmm, well here is a modification to your patch which might help further.
> I'll see if I can reproduce it here meanwhile.

I have reproduced it. It seems like it might be a livelock condition
because the system ended up recovering after I terminated the dd (and
did so before I collected any real info, oops, hopefully I can
reproduce it again).

This would fit with the problem going away when the debugging patch
was applied. Timing changes...
