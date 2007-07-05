Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbXGEMLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbXGEMLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbXGEMLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:11:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXGEMLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:11:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: The big suspend mess
Date: Thu, 5 Jul 2007 14:18:29 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <20070705002747.GA2952@elf.ucw.cz> <20070705012206.GN3492@stusta.de>
In-Reply-To: <20070705012206.GN3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051418.30138.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 03:22, Adrian Bunk wrote:
> On Thu, Jul 05, 2007 at 02:27:47AM +0200, Pavel Machek wrote:
> > 
> > > IMHO the suspend code is currently way too much of a moving target which 
> > > results in this mess.
> > > 
> > > The correct order seems to be:
> > 
> > 0. Get someone to sign up as a maintainer for suspend, so we have
> > someone to blame for the mess? :-)
> 
> The "SOFTWARE SUSPEND" entry in MAINTAINERS already contains a victim...  ;-)
> 
> My impression is that suspend is an area of the kernel that does not 
> lack maintainers - you and Rafael are doing a good job, and there's e.g. 
> also the maintained code formerly known as suspend2.
> 
> But some basic questions like e.g.
> - What should be done in the kernel and what in userspace?
> - How should this be implemented?
> - What must subsystems and drivers do?
> - What must subsystems and drivers not do?
> seem to be in a constant flux because the big picture everyone agrees 
> upon seems to be missing.

Well, to some extent I agree, but that's because it's difficult to reach such
an agreement and if we have one, new poeple come with new ideas and we need to
start all over again. :-)

In the meantime, problems are reported that need to be fixed and the fixes
often break other systems and we learn about that too late ect.

As far as the big picture is concerned, we have already agreed, or at least
this is my impression, that we need to separate the drivers' suspend callbacks
(as they exist today) from their hibernation callbacks (not present yet).

This seems to be needed for a couple of reasons, the first of them being that
the desired functionality of the hibernation code may be substantially
different from the desired functionality of the suspend code.  For instance,
it generally is not necessary to put devices into low power states, or to power
them off, in order to create the hibernation image, while it is necessary to do
that for a suspend.

It will require us to redesign the core quite a bit and I've already started to
prepare for that.  I really would like to do that in the first place and _then_
to think of improving both the suspend and hibernation code paths
_separately_.  This way, we can do things more easily and in a much more clean
way.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
