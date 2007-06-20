Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbXFTIGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbXFTIGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbXFTIGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:06:00 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:34015 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbXFTIF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:05:58 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Versioning file system
Date: Wed, 20 Jun 2007 10:05:15 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Snook <csnook@redhat.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan <alan@clueserver.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <20070619225021.225d4c7e@the-village.bc.nu> <467853BB.1090109@zytor.com>
In-Reply-To: <467853BB.1090109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201005.16323.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 20. Juni 2007, H. Peter Anvin wrote:
> Alan Cox wrote:
> > POSIX is very
> > clear about what is acceptable as magic in a pathname, and the unix spec
> > even more so.  The NetApp approach recognizes two important things
> >
> > 1.	Old version access is the oddity not the norm
> > 2.	Standards behaviour is important
>
> 3. An atomic snapshot is more useful than a bunch of disconnected
> per-file version.  Kind of like CVS vs SVN.

I believe that since some decision must be made *when* a snapshot is taken, 
and that should (has to) be done by userspace, a userspace versioning system 
for doing the backups is the right solution. [1]

Whether there is some filesystem (FUSE or native) that allows online browsing 
of the backups or not is another matter.

Ad 1: What userspace needs is
- atomic snapshots of complete directory trees, independent of mount
  boundaries (across filesystems)
- an atomic way to change the state of the filesystem for the *whole* system.
  For FSVS I'll try to use unionfs for that - populate some new directory with
  my tree of changes, then overmount that over "/", and move the files over
  one-by-one until the new directory is empty. (Must be checked on reboot, of
  course).

These are actually two similar operations (from the atomic view), but have to 
be done in completely different ways ... Maybe there could be some "better" 
interface (if there is one - I don't know what could really be removed from 
the above workflow).


Regards,

Phil
