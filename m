Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXD0KK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXD0KK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbXD0KK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:10:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32928 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbXD0KKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:10:25 -0400
Date: Fri, 27 Apr 2007 11:10:12 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070427101012.GA1714@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Xavier Bestel <xavier.bestel@free.fr>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <1177607026.30284.197.camel@frg-rhel40-em64t-04> <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org> <1177618081.4737.42.camel@nigel.suspend2.net> <20070426213806.GE24852@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426213806.GE24852@thunk.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 05:38:07PM -0400, Theodore Tso wrote:
> On Fri, Apr 27, 2007 at 06:08:01AM +1000, Nigel Cunningham wrote:
> > We tried that. It would need some work. IIRC remounting filesystems
> > read-only makes files become marked read-only. Perfectly sensible,
> > except that if you then remount the filesystem rw at resume time, all
> > those files are still marked ro and userspace crashes and burns. Not
> > unfixable, I'll agree, but there is more work to do there.
> 
> There are other solutions, though.  One is that we could export a
> system call interface which freezes a filesystem and prevents any
> further I/O.  We mostly have something like that right now (via the
> the write_super_lockfs function in the superblock operations
> structure), but we haven't exported it to userspace.

It is exported on XFS ;-)

> We would also need a similar interface to freeze any block device I/O,
> in case you have a database running and doing direct I/O to a block
> device.  (Or again, we could simply not support that case; how many
> people will be running running a database accessing a block deivce on
> their laptop?)

block device I/O uses generic_file*whateveriscurrenthere*_write, which
checks for the freeze flag, so the infrastructure for that is there
aswell.

