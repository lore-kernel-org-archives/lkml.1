Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYHYMCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYHYMCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYHYMB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:01:59 -0400
Received: from mail2.shareable.org ([80.68.89.115]:34358 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbYHYMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:01:58 -0400
Date: Mon, 25 Aug 2008 13:01:47 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>, gus3 <musicman529@yahoo.com>,
       Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Message-ID: <20080825120146.GC20960@shareable.org>
References: <20080821051508.GB5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au> <20080821170854.GJ5706@disturbed> <200808221229.11069.nickpiggin@yahoo.com.au> <20080825015922.GP5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825015922.GP5706@disturbed>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> To keep on top of this, we keep adding new variations and types and
> expect the filesystems to make best use of them (without
> documentation) to optimise for certain situations. Example - the
> new(ish) BIO_META tag that only CFQ understands. I can change the
> way XFS issues bios to use this tag to make CFQ behave the same way
> it used to w.r.t. metadata I/O from XFS, but then the deadline and
> AS will probably regress because they don't understand that tag and
> still need the old optimisations that just got removed. Ditto for
> prioritised bio dispatch - CFQ supports it but none of the others
> do.


There's nothing wrong with adding BIO_META (for example) and other
hints in _principle_.  You should be able to ignore it with no adverse
effects.  If its not used by a filesystem (and there's nothing else
competing to use the same disk), I would hope to see the same
performance as other kernels which don't have it.

If the elevators are being changed in such a way that old filesystem
code which doesn't use new hint bits is running significantly slower,
surely that's blatant elevator regression, and that's where the bugs
should be reported and fixed?

-- Jamie
