Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZHaBBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZHaBBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 21:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZHaBBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 21:01:06 -0400
Received: from science.horizon.com ([71.41.210.146]:57385 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751726AbZHaBBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 21:01:05 -0400
Date: 30 Aug 2009 20:54:26 -0400
Message-ID: <20090831005426.13607.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, there is something the file system can do to make journaling
safe on degraded RAIDs: make the (checksummed) journal blocks equal to
the RAID stripe size.  Or, equivalently, pad out to the RAID stripe
size each commit.

This sometimes leads to awkward block sizes, but while writing
to any *one* stripe on a degraded RAID-5 endangers the others, you
can write to *all* of them with the usual semantics.

That's something that's a good idea for performance anyway, so maybe
ext[34] should be more vociferous about it.  E.g. check each mount
and warn if the journal is mis-sized.  Or even change the journal
bock size on mount if it starts empty.

The other solution, of course, is RAID-1, which I like to use for
performance and simplicity reasons anyway.  (It's really something
of a degenerate case of the RAID-[456] rule.)

That's one thing I really like about ZFS: its policy of "don't trust
the disks."  If nothing else, simply telling you "your disks f*ed up,
and I caught them doing it", instead of the usual mysterious corruption
detectec three months later, is tremendoudly useful information.
