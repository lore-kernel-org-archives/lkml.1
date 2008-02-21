Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbYBUBLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbYBUBLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbYBUBKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:10:51 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:43458 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbYBUBKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:10:49 -0500
Date: Thu, 21 Feb 2008 01:10:32 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Message-ID: <20080221011032.GA30606@srcf.ucam.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <47BCAD6E.9080704@nigel.suspend2.net> <20080221001357.GA29796@srcf.ucam.org> <47BCC866.9000102@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BCC866.9000102@nigel.suspend2.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 11:40:06AM +1100, Nigel Cunningham wrote:
> Matthew Garrett wrote:
> >No, with a freezer-based model you can basically *never* suspend to 
> >anything related to FUSE or a userspace USB device or anything involving 
> >userspace iSCSI initiators or whatever. Sure, there are cases where 
> >moving away from the current model doesn't buy you anything, but that 
> >doesn't mean that the current model is a good thing. It's not. The 
> >freezer is a fundamentally broken concept.
> 
> Putting drivers and filesystems in userspace is the fundamentally broken 
> concept. Not just when it comes to the freezer. The whole idea is 
> inherently racy. You can draw silly diagrams about how the freezer 
> supposedly works in LCA slides and spread FUD as much as you like. In 
> the end, though, it's not nearly as hit-and-miss as you say, and 
> replacing the freezer with a kexec based freezer is only going to create 
> as many problems as it removes.

I'm really not interested in debating the matter. There are all sorts of 
potential uses for the freezer, but hibernation isn't one of them. We 
*need* to get rid of the freezer for suspend to RAM (because a band-aid 
to ensure atomicity is kind of pointless when the operation you're 
entering is inherently atomic), and once all the drivers are able to 
deal with that then it's trivial to get rid of it for hibernation as 
well. Arguing that the reality of userspace drivers is broken doesn't 
help here. It's what we have to work with.

> >You're looking at a tiny amount of memory when compared to current 
> >systems. It's really not a problem.
> 
> Please, quantify 'tiny'. In embedded, 5MB can be too much. I've worked 
> on embedded solutions. I'm not pulling problems out of thin air.

Then the in-kernel solution has already lost anyway, and I'm desperately 
unconcerned about out of tree stuff.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
