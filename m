Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbXGKLzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbXGKLzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbXGKLze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:55:34 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50821 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241AbXGKLzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:55:33 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu,
       pavel@ucw.cz, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <200707111350.41806.rjw@sisk.pl>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <200707111304.40504.rjw@sisk.pl> <E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu> <200707111350.41806.rjw@sisk.pl>
Message-Id: <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 13:54:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > regarding the freezer, how it is bad and how we should drop it,
> > > because it breaks things (which NB is not true, because it doesn't).
> > 
> > This thread started out from a bug, that seemed to be caused by the
> > freezer (we still don't exactly know what it was caused by), and the
> > discussion uncovered various problems _with_ the freezer, that up to
> > now no other _proper_ solutions have been propsed than to remove the
> > freezer.
> 
> First, please list those problems for completness.  Moreover, I think they
> should be documented if they haven't been yet.

Suspend failing due to ordering requirements from fuse, I think you
documented this one.

Suspend failing due to malicious/buggy fuse filesystem.

Suspend failing if network filesystem is mounted, and network or
server is down.  This is one of those "we can live with it" things
that only happen rarely, and it's annoying then, but soon forgotten.

Freezing of tasks is slowing down suspend.  Don't know how serious
this is, suspend is pretty fast, but could possibly be even faster.

Don't know what the OLPC guys do to make suspending extremely quick,
are they freezing any tasks?

> Second, there were many more problems with the freezer in the past and we
> were able to eliminate them over time.  It sometimes is difficult to invent a
> viable solution on demand ...

OK, if you elimitate all of the above problems with the freezer, I'll
say no more against it.

Miklos
