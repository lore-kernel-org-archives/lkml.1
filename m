Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZBEI7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZBEI7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBEI7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:59:23 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:12269 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbZBEI7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:59:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFg2ikl5LClx/2dsb2JhbADQToQWBg
X-IronPort-AV: E=Sophos;i="4.37,384,1231075800"; 
   d="scan'208";a="283374377"
Date: Thu, 5 Feb 2009 19:59:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sesterhenn <snakebyte@gmx.de>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090205085916.GP24173@disturbed>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Eric Sesterhenn <snakebyte@gmx.de>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
References: <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz> <20090121040042.GI10158@disturbed> <20090126162711.GA2083@elf.ucw.cz> <20090201014050.GD24173@disturbed> <20090204182951.GC4797@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090204182951.GC4797@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 07:29:51PM +0100, Pavel Machek wrote:
> On Sun 2009-02-01 12:40:50, Dave Chinner wrote:
> > On Mon, Jan 26, 2009 at 05:27:11PM +0100, Pavel Machek wrote:
> > > On Wed 2009-01-21 15:00:42, Dave Chinner wrote:
> > > +	  Turning this option on will result in kernel panicking any time
> > > +	  it detects on-disk corruption.
> > 
> > Thin end of a wedge. There's a couple of thousand conditions that
> > CONFIG_XFS_DEBUG introduces kernel panics on:
> > 
> > $ grep -r ASSERT fs/xfs |wc -l
> > 2095
> > 
> > 
> > CONFIG_*_DEBUG means include *debug* code there to help developers,
> > including adding additional failure tests into the kernel. Besides,
> > which bit of "don't turn it on unless you are an XFS developer"
> > don't you understand?
> 
> Yes, but DEBUG code is normally to help debugging, not to crash
> kernels.

Crashing the kernel at exactly the point a problem is detected
is often the simplest way of debugging the problem.

e.g. CONFIG_VM_DEBUG=y turns on VM_BUG_ON() which crashes the kernel
whenever it detects something wrong. Do I turn it on? Yes. Do i
complain about it when I hit a VM_BUG_ON()? No, I report the
bug and move on. If you turn on a DEBUG option, then you are
asking the system to behave in a way useful to a developer,
not an end user. That includes panicing when something wrong
is detected.

> IMO xfs should use errors=panic mount option as ext3 does,
> but...

We already have an equivalent:

/proc/sys/fs/xfs/panic_mask

The mask is empty on production kernels and can be selectively
turned on (depending on what error type you want to panic on).
CONFIG_XFS_DEBUG turns them all on by default so we can, weļl, panic
the system and debug any problem that occurs....

Cheers,

Dave,
-- 
Dave Chinner
david@fromorbit.com
