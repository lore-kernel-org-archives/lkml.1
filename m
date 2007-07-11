Return-Path: <linux-kernel-owner+w=401wt.eu-S932445AbXGKMMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbXGKMMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761839AbXGKMLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:11:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49787 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698AbXGKMLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:11:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 14:19:10 +0200
User-Agent: KMail/1.9.5
Cc: a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707111350.41806.rjw@sisk.pl> <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111419.11418.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 July 2007 13:54, Miklos Szeredi wrote:
> > > > regarding the freezer, how it is bad and how we should drop it,
> > > > because it breaks things (which NB is not true, because it doesn't).
> > > 
> > > This thread started out from a bug, that seemed to be caused by the
> > > freezer (we still don't exactly know what it was caused by), and the
> > > discussion uncovered various problems _with_ the freezer, that up to
> > > now no other _proper_ solutions have been propsed than to remove the
> > > freezer.
> > 
> > First, please list those problems for completness.  Moreover, I think they
> > should be documented if they haven't been yet.
> 
> Suspend failing due to ordering requirements from fuse, I think you
> documented this one.
> 
> Suspend failing due to malicious/buggy fuse filesystem.
> 
> Suspend failing if network filesystem is mounted, and network or
> server is down.  This is one of those "we can live with it" things
> that only happen rarely, and it's annoying then, but soon forgotten.

All of the above boil down to the freezer limitation regarding uninterruptible
tasks.  And yes, I think it should be explicitly documented.

> Freezing of tasks is slowing down suspend.  Don't know how serious
> this is, suspend is pretty fast, but could possibly be even faster.

Hmm, I don't know either.  I'm not seeing this in my tests, but well, more
data will be appreciated.

The sync probably slows down more than the freezing itself ...

> Don't know what the OLPC guys do to make suspending extremely quick,
> are they freezing any tasks?

They used to, but I'm not sure if they do.

> > Second, there were many more problems with the freezer in the past and we
> > were able to eliminate them over time.  It sometimes is difficult to invent a
> > viable solution on demand ...
> 
> OK, if you elimitate all of the above problems with the freezer, I'll
> say no more against it.

I think the ordering issue may be eliminated, to some extent.  I have a patch
for that, but you were CCed on that patch series, so you should know. ;-)

The other ones are more difficult, so time will tell.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
