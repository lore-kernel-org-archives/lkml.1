Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbXELG2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbXELG2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXELG2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 02:28:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60727 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXELG2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 02:28:07 -0400
Date: Sat, 12 May 2007 08:29:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] kbuild: silence section mismatch warnings
Message-ID: <20070512062901.GB4073@uranus.ravnborg.org>
References: <20070511210850.GA382@uranus.ravnborg.org> <8210B049-55BD-409F-8A5E-EC5E1C365604@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8210B049-55BD-409F-8A5E-EC5E1C365604@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 04:22:28PM -0500, Kumar Gala wrote:
> 
> On May 11, 2007, at 4:08 PM, Sam Ravnborg wrote:
> 
> >----- Forwarded message from Sam Ravnborg <sam@ravnborg.org> -----
> >
> >Forgot lkml in first mail...
> >
> >	Sam
> >
> >Subject: [RFC PATCH] kbuild: silence section mismatch warnings
> >From: Sam Ravnborg <sam@ravnborg.org>
> >Date: Fri, 11 May 2007 23:03:46 +0200
> >User-Agent: Mutt/1.4.2.1i
> >To: Chris Wedgwood <cw@f00f.org>, Andrew Morton <akpm@osdl.org>,
> >	"David S. Miller" <davem@redhat.com>,
> >	Russell King <rmk@arm.linux.org.uk>,
> >	Satyam Sharma <satyam.sharma@gmail.com>
> >Cc: sam@ravnborg.org
> >
> >Following patch allow us in specific places to silence section  
> >mismatch warnings.
> >There is a few legitime places that modpost does not yet recognize  
> >where
> >reference from .text to .init.text (likewise for data) are legitime.
> >This allow us to spot the few places and annotate them so we do not
> >get false warnings that in the end will let real warnings pass.
> >
> >The annotation is simple to grep for so revieing all uses in a few
> >months time are trivial. It is assumed that a few places will
> >use this to shut up the warning as replacement for the real fix.
> >But these cases are esay to spot and to fix up.
> 
> Its unclear if you expect that some things will be tagged  
> __init_refok/__initdata_refok forever or if we'll find some way to  
> fix/change the code so the things tagged no longer need it.

A few places will need the __init_refok tag forever.
But as Satyam points out it will likely be misused.

So the __init_refok is introduced to stay.

akpm pointed out in private mail that I need to update the
linker scripts too - and running out of time this weekend so that
will be later.

	Sam
