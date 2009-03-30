Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZC3Gb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZC3Gb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZC3GbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:31:17 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:27454 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbZC3GbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:31:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACMC0El5LJex/2dsb2JhbADHSYN6Bocj
X-IronPort-AV: E=Sophos;i="4.38,445,1233495000"; 
   d="scan'208";a="321521197"
Date: Mon, 30 Mar 2009 17:31:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330063110.GS26138@disturbed>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330003948.GA13356@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 08:39:48PM -0400, Theodore Tso wrote:
> On Mon, Mar 30, 2009 at 10:14:51AM +1100, Dave Chinner wrote:
> > This is a clear case where you want metadata changed before data is
> > committed to disk. In many cases, you don't even want the data to
> > hit the disk here.
> > 
> > Similarly, rsync does the magic open,write,close,rename sequence
> > without an fsync before the rename. And it doesn't need the fsync,
> > either. The proposed implicit fsync on rename will kill rsync
> > performance, and I think that may make many people unhappy....
> 
> I agree.  But unfortunately, I think we're going to be bullied into
> data=ordered semantics for the open/write/close/rename sequence, at
> least as the default.  Ext4 has a noauto_da_alloc mount option (which
> Eric Sandeen suggested we rename to "no_pony" :-), for people who
> mostly run sane applications that use fsync().
>
> For people who care about rsync's performance and who assume that they
> can always restart rsync if the system crashes while the rsync is
> running could, rsync could add Yet Another Rsync Option :-) which
> explicitly unlinks the target file before the rename, which would
> disable the implicit fsync().

Pardon my french, but that is a fucking joke.

You are making a judgement call that one application is more
important than another application and trying to impose that on
everyone. You are saying that we should perturb a well designed and
written backup application that is embedded into critical scripts
all around the world for the sake of desktop application that has
developers that are too fucking lazy to fix their bugs.

If you want to trade rsync performance for desktop performance, do
it in the filesystem that is aimed at the desktop. Don't fuck rename
up for filesystems that are aimed at the server market and don't
want to implement performance sucking hacks to work around fucked up
desktop applications.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
