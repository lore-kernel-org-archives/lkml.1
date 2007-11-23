Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbXKWE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbXKWE6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 23:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXKWE6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 23:58:08 -0500
Received: from thunk.org ([69.25.196.29]:45957 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbXKWE6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 23:58:06 -0500
Date: Thu, 22 Nov 2007 23:57:27 -0500
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: Why is FIBMAP ioctl root only?
Message-ID: <20071123045727.GB21854@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org
References: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz> <20071122102951.24e4e781@laptopd505.fenrus.org> <20071122195620.79c6ecf1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122195620.79c6ecf1@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 07:56:20PM +0000, Alan Cox wrote:
> > probably principle of least privilege; the location on physical media
> > for a file is clearly something internal to the OS, and non-trusted
> > users normally don't have any business knowing that. 
> 
> FIBMAP isn't correctly locked against misuse, and that requires FIBMAP is
> safe against truncate and relocation. There was thread on l/k about this
> a month ago or so.
> 
> Its also the wrong API (32bit, no notion of extents, compression etc)

The right approach would be to create a new syscall, and a new entry
point in the inode operations table, and filesystems could provide
support for the new system call as their bmap code was audited for
correctness.  

For bonus points the new interface would also provide make it more
efficient for filesystems to return information about extents.  (i.e.,
Not only is logical block 150 mapped to physical block 5550, it is
part of an 200 block extent starting at logical block 0 to physical
block 5400.)

						- Ted
