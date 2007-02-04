Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXBDNMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXBDNMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXBDNMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:12:55 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:42763 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXBDNMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:12:54 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 4 Feb 2007 07:57:43 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Theodore Tso <tytso@mit.edu>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: A CodingStyle suggestion
In-Reply-To: <20070204124819.GC12943@thunk.org>
Message-ID: <Pine.LNX.4.64.0702040754370.442@CPE00045a9c397f-CM001225dbafb6>
References: <20070203215848.GA10440@Ahmed> <20070203135951.564e5fe2.randy.dunlap@oracle.com>
 <20070204124819.GC12943@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007, Theodore Tso wrote:

> On Sat, Feb 03, 2007 at 01:59:51PM -0800, Randy Dunlap wrote:
> > On Sat, 3 Feb 2007 23:58:48 +0200 Ahmed S. Darwish wrote:
> > >
> > > In CodingStyle Chapter 16 "Function return value and names", why not
> > > adding a comment about the favorable community way of checking the return
> > > value. ie:
> > >
> > > ret = do_method();
> > > if (ret) {
> > >    /* deal with error */
> > > }
> > >
> > > and not other ways like:
> > >
> > > if (do_method()) or if ((ret = do_method()) > value) ...
> > >
> >
> > I like it.  Please cc: Andrew Morton <akpm@osdl.org> on it.
> > Hopefully he will merge it.
> >
>
> I'm going to have to disagree.  Sometimes if the main flow of the code
> is down, it's actually better to do this:
>
> 	if ((err = do_foo()) < 0)
> 		return (err);
> 	if ((err = do_bar(current, filp)) < 0)
> 		return (err);
> 	if ((err = do_quux(filp, buffer)) < 0) {
> 		close(filp);
> 		return (err);
> 	}
>
> Than to do something like this:
>
> 	err = do_foo();
> 	if (err < 0)
> 		return (err);
> 	err = do_bar(current, filp);
> 	if (err < 0)
> 		return (err);
> 	err = do_quux(filp, buffer);
> 	if (err < 0) {
> 		close(filp);
> 		return (err);
> 	}
>
> The first is more concise, and it draws the reader's eye to what's
> really going on.  The cleanup/return error path is less important,
> and and it's pretty clear what's going on just from glancing at it.
>
> 						- Ted

i doubt you're going to get consensus on the *best* way to write this,
but it would be worthwhile to at least agree on the really *bad*
variations that shouldn't be used, the most vile one being:

  ret = whatever();
  if (ret) {
	...
  }

when there are no more references to "ret" inside the "if" construct,
which means there was no need to declare "ret" in the first place.

i'm guessing we can all agree on *that* but, beyond that, i think it's
going to be a matter of personal preference.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
