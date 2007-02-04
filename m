Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbXBDMse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbXBDMse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 07:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbXBDMse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 07:48:34 -0500
Received: from thunk.org ([69.25.196.29]:40768 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbXBDMsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 07:48:33 -0500
Date: Sun, 4 Feb 2007 07:48:19 -0500
From: Theodore Tso <tytso@mit.edu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: A CodingStyle suggestion
Message-ID: <20070204124819.GC12943@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"Ahmed S. Darwish" <darwish.07@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20070203215848.GA10440@Ahmed> <20070203135951.564e5fe2.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203135951.564e5fe2.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 01:59:51PM -0800, Randy Dunlap wrote:
> On Sat, 3 Feb 2007 23:58:48 +0200 Ahmed S. Darwish wrote:
> > 
> > In CodingStyle Chapter 16 "Function return value and names", why not
> > adding a comment about the favorable community way of checking the return
> > value. ie:
> > 
> > ret = do_method();
> > if (ret) {
> >    /* deal with error */
> > }
> > 
> > and not other ways like:
> > 
> > if (do_method()) or if ((ret = do_method()) > value) ...
> > 
> 
> I like it.  Please cc: Andrew Morton <akpm@osdl.org> on it.
> Hopefully he will merge it.
> 

I'm going to have to disagree.  Sometimes if the main flow of the code
is down, it's actually better to do this:

	if ((err = do_foo()) < 0)
		return (err);
	if ((err = do_bar(current, filp)) < 0)
		return (err);
	if ((err = do_quux(filp, buffer)) < 0) {
		close(filp);
		return (err);
	}

Than to do something like this:

	err = do_foo();
	if (err < 0)
		return (err);
	err = do_bar(current, filp);
	if (err < 0)
		return (err);
	err = do_quux(filp, buffer);
	if (err < 0) {
		close(filp);
		return (err);
	}

The first is more concise, and it draws the reader's eye to what's
really going on.  The cleanup/return error path is less important, and
and it's pretty clear what's going on just from glancing at it.

						- Ted

		
		
