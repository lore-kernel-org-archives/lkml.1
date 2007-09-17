Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbXIQBT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbXIQBT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 21:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbXIQBTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 21:19:20 -0400
Received: from THUNK.ORG ([69.25.196.29]:38076 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXIQBTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 21:19:19 -0400
Date: Sun, 16 Sep 2007 21:19:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Schwartz <davids@webmaster.com>
Cc: bunk@kernel.org,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917011914.GE5502@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Schwartz <davids@webmaster.com>, bunk@kernel.org,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <20070916230936.GC18232@stusta.de> <MDEHLPKNGKAHNMBLJOLKOEFKGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEFKGNAC.davids@webmaster.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 05:29:56PM -0700, David Schwartz wrote:
> In responses and posts, there is over and over a huge confusion
> between two completely different issues. One is about whether you
> can modify licenses, the other is about whether you can modify
> license *notices*.
> 
> Again, one more time:
> 
> 1) You can obtain, from the GPL, the right to remove a BSD license notice.
> 
> 2) You can obtain, from the BSD license, the right to remove a GPL
> license notice.
> 
> 3) Neither of these actions has any effect on the fact that these
> licenses still exist from the original author and still grant rights
> to anyone who comes into lawful possession of the work.
> 
> Of course, if you take a dual-licensed file, remove the BSD notice,
> and then add more to it, those contributions can be offered *by*
> *their* *original* *authors* under only the GPL.

Careful; the devil is really in the details on this one.  If you have
a file where all of the code was originally dual licensed (say, like
drivers/char/random.c, which was written by me and deliberately dual
licensed because I wanted other OS's to be able to use it), then this
might be true.

However, consider a file which was originally BSD licensed.  Now
suppose it is modified (i.e., a derived work was created) and another
author slaps on a BSD/GPL dual notice.  That's fine, so far; the BSD
license on the original file permits that.  The new code is licensed
under either BSD or GPL (user's choice), and the original code is
under the BSD license, which is compatible with the GPL code, so
regardless of whether the user choose the BSD or GPL license.

However, in such a case it is **NOT** kosher to remove the BSD license
notification.  Why?  Because the lines of code from the original file
was originally licensed under the BSD only.  The second author who
added the BSD/GPL'ed dual license only has the authority to release
the the code which he or she added under the BSD/GPL dual license.
The original code remains only licensed under the BSD license, but
that was OK because the BSD license is compatible with the GPL (but
not vice versa).


Now, in the case of the Atheros wireless code, the original author
(Sam Leffler) has stated that as far as *his* code was concerned, he
was willing to dual license it.  However, in this case, he agreed to
have the code dual-licensed three years after the project was started.
He was amused and had no objections to people retroactively applying
the licensing changes to code that was 3 years old.[1]

HOWEVER, he can only speak for himself.  If anyone in the first 3
years of the project made significant code contributions, they would
have reasonably expected them to be made under the BSD license, and
Sam's agreement to dual-license his code wouldn't apply to some other
major contributor.  And if there is any code which was not written by
Sam contributed dring the first 3 years, then it could only be
distributed under the terms of the BSD license, regardless of Sam's
statements.

This may be one of the reasons why Eben said that very careful
research needs to be done before making any definitive statement on
the subject.  Personally, my recommendation would just be to include
the original copyright statement (removing attribution is bad ju-ju)
and also to leave BSD permission statement in place.  Yes, maybe after
doing a huge amount of research we might be able to determine that all
of the code belonged to Sam at the point when he agreed to dual
license it, but is it worth it to make 100% sure of this question?
Why not just leave the BSD statement in place, and be done with it.
We've done this before; for example, take a look at drivers/net/slhc.c
as evidence of the fact that we do have some BSD code in the Linux
kernel, and having the BSD permission notice really doesn't hurt
anyone.


[1]  http://lkml.org/lkml/2007/9/1/160

						- Ted
