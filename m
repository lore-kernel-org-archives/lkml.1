Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbXGKK53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbXGKK53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbXGKK5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:57:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49224 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842AbXGKK5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:57:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 13:04:39 +0200
User-Agent: KMail/1.9.5
Cc: a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707111227.52609.rjw@sisk.pl> <E1I8Ze4-0008OM-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8Ze4-0008OM-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200707111304.40504.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 July 2007 12:42, Miklos Szeredi wrote:
> > > > Yes, I suppose.  You're certain the old kernel's devices are completely
> > > > quiescent at that point?
> > > 
> > > That's exactly the problem; trying to save a state from within the
> > > kernel would probably necessitate a freezer hack, which we are
> > > trying so dearly to avoid.
> > 
> > Well, I don't think that avoiding the freezer whatever it takes
> > would be a good idea.  There needs to be some balance. ;-)
> 
> Well, it takes some extra locking in the drivers.  Which is needed
> _anyway_ if we want to have a working s2ram without the freezer.
> 
> With the kexec approach, I don't see any extra requirements from the
> kernel to be able to drop the freezer.

This is not my point.  I think that if what it takes to implement the kexec
approach, as a complete working solution, is much more complicated than
what we have now, then the current soultion is favorable.

Anyway, to implement the kexec approach we must separate the hibernation
from the suspend at the drivers level, which I'm still going to do, but I need to
take part in endless discussions regarding the freezer, how it is bad and
how we should drop it, because it breaks things (which NB is not true, because
it doesn't).

>From a practical point of view, the freezer is not the most problematic part
of the infrastructure.  For example, none of the bug reports that we have
registered in the bugzilla is related to the freezer.  Moreover, to drop it,
we first need to redesign the other things.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
