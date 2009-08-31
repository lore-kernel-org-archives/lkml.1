Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZHaLE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZHaLE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZHaLE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:04:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38496 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZHaLE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:04:56 -0400
Date: Mon, 31 Aug 2009 13:04:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: George Spelvin <linux@horizon.com>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Message-ID: <20090831105645.GD1353@ucw.cz>
References: <20090831005426.13607.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831005426.13607.qmail@science.horizon.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Actually, there is something the file system can do to make journaling
> safe on degraded RAIDs: make the (checksummed) journal blocks equal to
> the RAID stripe size.  Or, equivalently, pad out to the RAID stripe
> size each commit.
> 
> This sometimes leads to awkward block sizes, but while writing
> to any *one* stripe on a degraded RAID-5 endangers the others, you
> can write to *all* of them with the usual semantics.

Well, that would work... but you'd also have to journal data, with the
same block size. Not exactly fast, but at least safe...

> That's one thing I really like about ZFS: its policy of "don't trust
> the disks."  If nothing else, simply telling you "your disks f*ed up,
> and I caught them doing it", instead of the usual mysterious corruption
> detectec three months later, is tremendoudly useful information.

The more I learn about storage, the more I like idea of zfs. Given the
subtle issues between filesystem and raid layer, integrating them just
makes sense.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
