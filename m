Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbXGHTCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbXGHTCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 15:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbXGHTBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 15:01:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbXGHTBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 15:01:54 -0400
Date: Sun, 8 Jul 2007 12:00:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Ulrich Drepper <drepper@redhat.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference
 - git-bisect result
In-Reply-To: <20070708185118.GL21668@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.999.0707081158340.31544@woody.linux-foundation.org>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
 <20070708012016.455ce8d5.akpm@linux-foundation.org>
 <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de>
 <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk>
 <469121DA.6030600@redhat.com> <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707081126260.31544@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707081130420.31544@woody.linux-foundation.org>
 <20070708185118.GL21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Jul 2007, Al Viro wrote:
>
> I think that we need to go the other way round - gather nameidata
> ->nd and ->dentry into struct path and pass pointer to that instead...

Yeah, that sounds fine too.

> But that's .23-rc1 fodder, if not .23-rc2 one (we might want to
> do -rc2 with just that, to avoid conflicts with pending patches).
> Definitely not for .22-final.

Oh, absolutely. I wasn't implying that we would want to do it today, but 
as it is now, just looking at that code makes my eyes water.. So it would 
be nice to fix that up.

One reason I would almost prefer an "nd", though, is that it would allow 
us to in general always just convert anythign that now looks up a path to 
look up "a path or file descriptor" instead. Those things need "nd" right 
now, and if it's a "struct path", then you'll always have the two 
different cases, rather than just the common "release_nd()" at the end.

		Linus
