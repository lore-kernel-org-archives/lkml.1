Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZBABlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZBABlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZBABk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:40:56 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:15891 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbZBABk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:40:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHuMhEl5LJ2q/2dsb2JhbADIDoQUBg
X-IronPort-AV: E=Sophos;i="4.37,357,1231075800"; 
   d="scan'208";a="307562403"
Date: Sun, 1 Feb 2009 12:40:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sesterhenn <snakebyte@gmx.de>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090201014050.GD24173@disturbed>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Eric Sesterhenn <snakebyte@gmx.de>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
References: <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz> <20090121040042.GI10158@disturbed> <20090126162711.GA2083@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126162711.GA2083@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 05:27:11PM +0100, Pavel Machek wrote:
> On Wed 2009-01-21 15:00:42, Dave Chinner wrote:
> > On Tue, Jan 20, 2009 at 11:20:19PM +0100, Pavel Machek wrote:
> > > On Tue 2009-01-20 08:28:29, Christoph Hellwig wrote:
> > > > I think that was the issue with the debug builds.  If you do this
> > > > testing always do it without CONFIG_XFS_DEBUG set as with that option
> > > > we intentionally panic on detected disk corruptions.
> > > 
> > > Uhuh, *_DEBUG options are not supposed to make kernel less
> > > stable/robust. Should that crashing functionality be guarded with
> > > command line option or something? ext2 has errors=panic mount
> > > option...
> > 
> > No, it's a debugging option that is described as:
> > 
> > 	"Say N unless you are an XFS developer, or you play one on TV."
> > 
> > Seriously, if you aren't trying to develop XFS stuff then *don't turn it
> > on*.
> 
> What about this, then?

....

> +	  Turning this option on will result in kernel panicking any time
> +	  it detects on-disk corruption.

Thin end of a wedge. There's a couple of thousand conditions that
CONFIG_XFS_DEBUG introduces kernel panics on:

$ grep -r ASSERT fs/xfs |wc -l
2095


CONFIG_*_DEBUG means include *debug* code there to help developers,
including adding additional failure tests into the kernel. Besides,
which bit of "don't turn it on unless you are an XFS developer"
don't you understand?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
