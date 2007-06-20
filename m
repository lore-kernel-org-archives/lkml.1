Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbXFTR2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbXFTR2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXFTR2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:28:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47845 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbXFTR2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:28:30 -0400
Date: Wed, 20 Jun 2007 13:28:09 -0400
Message-Id: <200706201728.l5KHS9hj029372@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-kernel@vger.kernel.org, jsipek@ic.sunysb.edu
Subject: Re: [RFC PATCH 1/4] Union mount documentation. 
In-reply-to: Your message of "Wed, 20 Jun 2007 07:29:55 -0000."
             <f5al1i$foi$1@sea.gmane.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <f5al1i$foi$1@sea.gmane.org>, Jan Blunck writes:
> On Tue, 19 Jun 2007 22:59:51 -0700, Arjan van de Ven wrote:
> 
> > first of all I'm happy to see that people are still working on unionfs;
> > I'd love to have functionality like this show up in Linux.
> 
> This has nothing to do with unionfs. This is about doing a VFS based
> approach to union mounts. Unification is a name-based construct so it
> belongs into VFS and not into a separate file system.

Jan, while I agree with you in principle that unification is a VFS-level
namespace construct, I disagree with you that unioning doesn't belong in a
separate f/s.

As someone whose group developed three generations of the stackable file
system Unionfs (see http://unionfs.filesystems.org/), I can tell you from my
experience and the experience of numerous users, that the devil is the
details -- or the so-called orthogonal issues.  To get a fully working
unioning implementation, one that the many current users of Unionfs could
use, you'll have to deal with many issues and corner cases: cache coherency,
inode persistency (and network f/s exports), copyups, whiteouts and opaque
dirs, how to deal with "odd" file systems which don't support native
whiteouts and such, directory reading (seekdir), and more.  Our third
generation Unionfs, the one with On-Disk Format (ODF), handles all of these.
Rather than reproduce all that discussion here, I'll point people to read
more info here: <http://www.filesystems.org/unionfs-odf.txt>

So, to have a fully usable union mounts implementation, you're going to have
to support a lot of existing features; but if you were to support them all
at the VFS level, you will have bloated the VFS considerably with stuff that
many would argue does not belong in the VFS.

Sincerely,
Erez Zadok.
