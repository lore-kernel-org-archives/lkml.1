Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYBLFdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYBLFdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYBLFdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:33:37 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47949 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751608AbYBLFdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:33:35 -0500
Date: Tue, 12 Feb 2008 00:11:36 -0500
From: Theodore Tso <tytso@mit.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080212051136.GA12802@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus <torvalds@linux-foundation.org>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <20080211203146.3d28d1a0@laptopd505.fenrus.org> <1202791555.20739.6.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202791555.20739.6.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:45:55PM -0500, Trond Myklebust wrote:
> It would be very nice to have a separate tree with _only_ API changes
> that could be frozen well before Linus' merge window opens. It should be
> a requirement that maintainers use this tree as a basis for testing API
> changes and even test that their own changesets were properly integrated
> with the changed APIs.

The other way that might work in some circumstances would be if we
tried a little harder to avoid API changes that don't involve an
interface naming change.  That is, instead of adding a new parameter
to a function, and then having to sweep through all of the trees to
catch all of the users of siad function, we could instead add a new a
new interface, __deprecate the old one, and then give enough time for
trees to adapt, you can avoid needing to do flag day transitions.  If
the old interface is __deprecated at the beginning of the merge
window, and then disappears at the very end of the merge window,
that's plenty of time for the subsystem maintainers to move to the new
interface.

This doesn't always work, of course (for example, if we make a
fundamental change in how some critical low-level data structure is
locked).  But every little bit that we can do to avoid the tree
integration pain would be a win.

Regards,

						- Ted
