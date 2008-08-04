Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbYHDQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbYHDQwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYHDQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:52:06 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44021 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753802AbYHDQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:52:05 -0400
Date: Mon, 4 Aug 2008 12:51:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: ext3 seems to ignore ECC errors
Message-ID: <20080804165156.GI8592@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org
References: <20080804150353.GS4470@implementation.uk.xensource.com> <je8wvczt5x.fsf@sykes.suse.de> <20080804154727.GV4470@implementation.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080804154727.GV4470@implementation.uk.xensource.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 04:47:27PM +0100, Samuel Thibault wrote:
> Andreas Schwab, le Mon 04 Aug 2008 17:39:06 +0200, a écrit :
> > Samuel Thibault <samuel.thibault@ens-lyon.org> writes:
> > > However, to my surprise Linux (2.6.26) continued to mount the ext3
> > > filesystem read/write, spitting out a lot of IDE errors.  Shouldn't
> > > filesystems remount read-only and let the admin try to save data in such
> > > case?
> > 
> > That's a tunable parameter of the filesystem, see tune2fs(8).
> 
> Oh, I had assumed it was on by default, hum.  But now it reads
> 
> Errors behavior:          Remount read-only
> 
> and I am still getting the same behavior.  Indeed after some VFS
> modifications time it gets remounted read-only, but shouldn't that
> happen as soon as possible?

Errors writing to data blocks should get reflected up the application
(i.e., as EIO errors), but it won't force the filesystem read/only or
force a kernel panic (in the "tune2fs -e panic" case).  The rationale
being if it's a single isloated error writing to a single file, why
ruin everybody's day by taking more drastic action?

But if we can't write to core filesystem data structures, that's a
much more serious situation....

						- Ted
