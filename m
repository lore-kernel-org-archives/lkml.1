Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbXJBStf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbXJBStf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbXJBSt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:49:28 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34388 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbXJBSt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:49:27 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 2 Oct 2007 14:47:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Oleg Verych <olecom@flower.upol.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Extend "memparse" to allow a NULL return pointer
 value.
In-Reply-To: <E1IZYQy-0007zL-Us@flower>
Message-ID: <Pine.LNX.4.64.0710021443520.1874@localhost.localdomain>
References: <Pine.LNX.4.64.0709151217530.16440@localhost.localdomain>
 <E1IZYQy-0007zL-Us@flower>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Sep 2007, Oleg Verych wrote:

> * Sat, 15 Sep 2007 12:27:07 -0400 (EDT)
>
> > Extend the memparse() routine to allow a caller to use NULL as the
> > second parameter value if he has no interest in that returned value.
>
> (not `he', but `it', even if `he', then better `callers' + `they')
>
> > ---
> >
> >   there appear to be quite a number of calls to "memparse" which
> > have no use for the value returned in the second parameter (the
> > current pointer after the successful parse), but which are still
> > forced to supply a valid char** address since they have no choice
> > but to accept that value coming back.  in many cases, that value
> > is accepted just before the end of the calling function, making it
> > clear that the value is ignored entirely, anyway.
>
> A posteriori value, stored in this pointer serves very important
> role: it validates returned result. Caller must do this. But if
> programmer doesn't know problems (see below), `must' melts down to
> `may'.
>
> If you take a look at simple_strtoull(), it already doesn't care if
> this pointer is NULL or not. (So patch is NULL :)
>
> But take closer look. If it returns `0' (zero), it is not clear if
> this zero was parsed or not, unless you can compare `ptr' and
> `retptr'. Another case if entire string have no valid number to
> parse (see strtol(3)).
>
> This is problem of this particular function, that is copied form
> ordinary C. For instance see <http://bugs.debian.org/431320>.

i'm sorry, i'm not sure what you're getting at here.  all this patch
does is allow memparse to accept a NULL second argument if the caller
has no interest in what is normally passed back in that argument.
and there are certainly *numerous* places in the source where callers
are passing a bogus second argument just because they have to pass
*something*.

allowing NULL as a second arg just makes it more visually obvious that
the caller isn't interested in that return value.  or is there
something more subtle going on here that i'm not understanding?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
