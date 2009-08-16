Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZHPBds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZHPBds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 21:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZHPBds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 21:33:48 -0400
Received: from thunk.org ([69.25.196.29]:35818 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZHPBdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 21:33:47 -0400
Date: Sat, 15 Aug 2009 21:33:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Message-ID: <20090816013346.GA17958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Wagner <daw-news@cs.berkeley.edu>,
	linux-kernel@vger.kernel.org
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <20090816003326.GC7554@mit.edu> <h67kou$ahr$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h67kou$ahr$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 12:44:14AM +0000, David Wagner wrote:
> Theodore Tso  wrote:
> > A configuration option which defaults to disabling ESP and EIP would
> > be a simple way to prevent this specific instance of information
> > leakage.  The problem is there are other files that might reveal
> > timing information, but which are very useful for a system
> > administrator.  A key example of this is /proc/$pid/wchan, which is
> > responsible for the WCHAN column is a ps listing.
> 
> If they're useful for system administrators, would making them
> readable to root (but not everyone) be enough?

I suppose sysadmins use "sudo ps" instead of "ps", but that would be a
bit inconvenient and would certainly clutter the sudo logs.  It might
also cause people to decide it's more trouble than it's worth, and
configure their system not restrict the various proc files.

That's why I think it would be useful to restrict the number of times
any process in the system can sample the files before the system
starts inserting random delays, thus destroying the usefulness of
using wchan for mounting timing attacks, without removing system
functionality.

						- Ted

