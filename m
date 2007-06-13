Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbXFMO6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbXFMO6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXFMO6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:58:37 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61375 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbXFMO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:58:36 -0400
Date: Wed, 13 Jun 2007 10:54:42 -0400
From: Chris Mason <chris.mason@oracle.com>
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070613145442.GC28279@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com> <18031.26764.586958.632146@stoffel.org> <20070613103522.GW28279@think.oraclecorp.com> <18031.63640.103936.137412@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18031.63640.103936.137412@stoffel.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 10:00:56AM -0400, John Stoffel wrote:
> >>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:
> >> As a user of Netapps, having quotas (if only for reporting purposes)
> >> and some way to migrate non-used files to slower/cheaper storage would
> >> be great.
> 
> Chris> So far, I'm not planning quotas beyond the subvolume level.
> 
> So let me get this straight.  Are you saying that quotas would only be
> on the volume level, and for the initial level of sub-volumes below
> that level?  Or would *all* sub-volumes have quota support?  And does
> that include snapshots as well?

On disk, snapshots and subvolumes are identical...the only difference is
their starting state (sorry, it's confusing, and it doesn't help that I
interchange the terms when describing features).

Every subvolume will have a quota on the number of blocks it can
consume.  I haven't yet decided on the best way to account for blocks
that are actually shared between snapshots, but it'll be in there
somehow.  So if you wanted to make a snapshot readonly, you just set the
quota to 1 block.

But, I'm not planning on adding a way to say user X in subvolume Y has
quota Z.  I'll just be: this subvolume can't get bigger than a given
size.  (at least for version 1.0).

-chris

