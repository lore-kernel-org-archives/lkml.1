Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbXIXTZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbXIXTZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763153AbXIXTYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:24:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57707 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763136AbXIXTYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:24:30 -0400
Date: Mon, 24 Sep 2007 20:24:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Hansen <haveblue@us.ibm.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-ID: <20070924192425.GA6629@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <20070920195249.852667D5@kernel> <20070920195320.38C8E20D@kernel> <20070924175411.GA2314@infradead.org> <20070924121035.8d8c6ce2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924121035.8d8c6ce2.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 12:10:35PM -0700, Andrew Morton wrote:
> > As we already say in various messages the percpu counters in here
> > look rather fishy.  I'd recomment to take a look at the per-cpu
> > superblock counters in XFS as they've been debugged quite well
> > now and could probably be lifted into a generic library for this
> > kind of think.  The code is mostly in fs/xfs/xfs_mount.c can
> > can be spotted by beeing under #ifdef HAVE_PERCPU_SB.
> > 
> > It also handles cases like hotplug cpu nicely that this code
> > seems to work around by always iterating over all possible cpus
> > which might not be nice on a dual core laptop with a distro kernel
> > that also has to support big iron.
> 
> hm.  How come xfs invented a new version of percpu_counters?

This code actually predates the generic percpu_counters even if it
was merged to mainline later.  Neither Dave who wrote it nor me
who reviewed it before it was merged thought of percpu_counters
probably.  Then again this code is considerably more complex due
to features actually needed in a very hot fastpath.
