Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZD0Rej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZD0Rej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZD0Rea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:34:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbZD0Rea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:34:30 -0400
Date: Mon, 27 Apr 2009 18:34:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [rfc] built-in native compiler for Linux?
Message-ID: <20090427173420.GD8633@ZenIV.linux.org.uk>
References: <20090422085828.GA16917@elte.hu> <alpine.DEB.1.10.0904241429450.19686@qirst.com> <20090424.222952.83381016.davem@davemloft.net> <m163gtxle9.fsf@fess.ebiederm.org> <alpine.DEB.1.10.0904270950580.16119@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904270950580.16119@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 09:52:46AM -0400, Christoph Lameter wrote:
> On Sat, 25 Apr 2009, Eric W. Biederman wrote:
> 
> > If this was about teaching sparse to run lockdep at compile time, or
> > generally about making the kernel compilation much faster and able to
> > catch many more bugs there might be a point where the effort is worth
> > the investment.
> 
> The preprocessor and its interaction with regular C code is quite
> nasty. If sparse could get rid of the complexities and idiosyncrasies at
> that level then it may be useful as a "pre" compiler.

Explain, please.  BTW, at the risk of being called an elitist bastard, could
I ask the participants of that thread to read C99 standard?  It's not hard
to find (http://www.open-std.org/jtc1/sc22/WG14/www/docs/n1256.pdf, for one
thing - that's C99 + errata) and at least chapter 5 and 6.10 are really
must-read if we are talking about that stuff.

In particular, C preprocessor does *NOT* work on text-to-text level and
hasn't since way back.  It works on token stream.

That's actually one of the areas where C99 is a huge improvement over
earlier language - instead of more or less nasty kludges still trying
to pretend that preprocessor was a filter with text output piped into
compiler, it gives reasonably clear semantics approximating what the
earlier variants had in common.

I'd done fairly complete rewrite of macro expansion (and a bunch of other
places in preprocessor) in sparse, and places where it used to deviate from
standard were by far the worst in terms of convoluted logics and corner
cases.  Switching to what C99 asked had simplified the things a *lot*;
it's surprisingly well thought through in that area (unlike e.g. the unholy
mess around 'restrict' qualifier semantics).
