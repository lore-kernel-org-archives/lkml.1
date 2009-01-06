Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbZAFPbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbZAFPbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZAFPa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:30:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZAFPa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:30:56 -0500
Date: Tue, 6 Jan 2009 16:30:55 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mike Travis <travis@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Cliff Wickman <cpw@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
Message-ID: <20090106153055.GJ16738@wotan.suse.de>
References: <20090106060348.GA16738@wotan.suse.de> <20090106143330.GB18913@sgi.com> <20090106144843.GH16738@wotan.suse.de> <49637346.6060105@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49637346.6060105@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 07:05:42AM -0800, Mike Travis wrote:
> Nick Piggin wrote:
> > On Tue, Jan 06, 2009 at 08:33:30AM -0600, Jack Steiner wrote:
> >> On Tue, Jan 06, 2009 at 07:03:48AM +0100, Nick Piggin wrote:
> >>> UV is fairly rare.... and much of the support is already there to cope with
> >>> 32-bit builds. So this makes sense I think.
> 
> What, you haven't heard of "UV on a chip"?  It will be in every
> smart phone soon... ;-)

NUMAlink over microwave? Cool!


> >> Looks ok to me. One suggestion though. There is a MAXSMP config
> >> option. I would suggest enabling UV if MAXSMP is enabled. This
> >> will help ensure that UV is tested more frequently & may minimize
> >> regressions.
> > 
> > Yeah.... I don't know. OTOH it would be more logical to enable
> > MAXSMP iff UV is enabled (or change the MAXSMP limits for when
> > UV is enabled). Or you could select Intel CPUs if UV is enabled,
> > or disable GRU if UV is not set etc etc.
> > 
> > I didn't want to get too fancy with config options because arbitrary
> > linkages seem to just cause headaches. I figure if someone wants
> > to enable it, they can do so.
> > 
> 
> Hi Nick,
> 
> The problem arises that if the option becomes too obscure (and never
> enabled), then it won't get tested.  We (as many companies do) rely on
> distros to certify applications and security features using a standard
> kernel, and if an option (such as X86_UV) causes any problems whatsoever,
> they'll drop it and we no longer have that application certification.

I wouldn't be so pessimistic ;) The people involved should have a
shared interest in the feature so then they will fix it.

It might be nice for one person to enable their code on everyone's
builds, but it's kind of a selfish viewpoint (imagine if everyone
did it).


> Currently, Ingo's test setup sets MAXSMP quite a bit and he's found
> many problems with large NR_CPUS counts that we never would have found
> ourselves.  Please don't make that process any harder.
 
Ingo's setup does randconfigs I think? Then it should pick up this
option.


> In fact, 13k is peanuts.

Ahh, you SGIers ;) Everything adds up, and 13k is a gold mine
for some people, especially considering how unintrusive the patch
is.


>  Why don't you set something like "very minimal
> support" and drop all obsolete features, anything older than a couple of
> years, anything not available from Dell ;-)  Perhaps call it "Desktop
> System"?

Well, because I don't perceive any benefit from doing that :)

In the end I don't want to make a big deal of it so long as it is
configurable. I'll resubmit the patch, and let others play with
Kconfig...

