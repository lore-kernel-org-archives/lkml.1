Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZBDSaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZBDSaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZBDSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:30:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58669 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZBDSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:30:05 -0500
Date: Wed, 4 Feb 2009 19:29:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: Christoph Hellwig <hch@infradead.org>, Eric Sesterhenn <snakebyte@gmx.de>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090204182951.GC4797@elf.ucw.cz>
References: <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz> <20090121040042.GI10158@disturbed> <20090126162711.GA2083@elf.ucw.cz> <20090201014050.GD24173@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090201014050.GD24173@disturbed>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-02-01 12:40:50, Dave Chinner wrote:
> On Mon, Jan 26, 2009 at 05:27:11PM +0100, Pavel Machek wrote:
> > On Wed 2009-01-21 15:00:42, Dave Chinner wrote:
> > > On Tue, Jan 20, 2009 at 11:20:19PM +0100, Pavel Machek wrote:
> > > > On Tue 2009-01-20 08:28:29, Christoph Hellwig wrote:
> > > > > I think that was the issue with the debug builds.  If you do this
> > > > > testing always do it without CONFIG_XFS_DEBUG set as with that option
> > > > > we intentionally panic on detected disk corruptions.
> > > > 
> > > > Uhuh, *_DEBUG options are not supposed to make kernel less
> > > > stable/robust. Should that crashing functionality be guarded with
> > > > command line option or something? ext2 has errors=panic mount
> > > > option...
> > > 
> > > No, it's a debugging option that is described as:
> > > 
> > > 	"Say N unless you are an XFS developer, or you play one on TV."
> > > 
> > > Seriously, if you aren't trying to develop XFS stuff then *don't turn it
> > > on*.
> > 
> > What about this, then?
> 
> ....
> 
> > +	  Turning this option on will result in kernel panicking any time
> > +	  it detects on-disk corruption.
> 
> Thin end of a wedge. There's a couple of thousand conditions that
> CONFIG_XFS_DEBUG introduces kernel panics on:
> 
> $ grep -r ASSERT fs/xfs |wc -l
> 2095
> 
> 
> CONFIG_*_DEBUG means include *debug* code there to help developers,
> including adding additional failure tests into the kernel. Besides,
> which bit of "don't turn it on unless you are an XFS developer"
> don't you understand?

Yes, but DEBUG code is normally to help debugging, not to crash
kernels. IMO xfs should use errors=panic mount option as ext3 does,
but...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
