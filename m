Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535Ab0AYRsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0AYRsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519Ab0AYRsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:48:01 -0500
Received: from THUNK.ORG ([69.25.196.29]:56732 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab0AYRr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:47:58 -0500
Date: Mon, 25 Jan 2010 12:47:23 -0500
From: tytso@mit.edu
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Nick Piggin <npiggin@suse.de>,
       Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: IO error semantics
Message-ID: <20100125174723.GB28459@thunk.org>
Mail-Followup-To: tytso@mit.edu, Ric Wheeler <rwheeler@redhat.com>,
	Anton Altaparmakov <aia21@cam.ac.uk>, Nick Piggin <npiggin@suse.de>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	linux-fsdevel@vger.kernel.org
References: <4B4EB5B9.4020809@hitachi.com>
 <4B4EDE5C.8040600@hitachi.com>
 <4B4EEE86.7080807@hitachi.com>
 <20100114141803.GB3146@quack.suse.cz>
 <20100118051847.GA8678@laptop>
 <20100118060518.GA9151@laptop>
 <20100118122437.GF7264@discord.disaster>
 <20100118140039.GA13909@laptop>
 <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk>
 <4B5DB78D.2090408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5DB78D.2090408@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 10:23:57AM -0500, Ric Wheeler wrote:
> 
> For permanent write errors, I would expect any modern drive to do a
> sector remapping internally. We should never need to track this kind
> of information for any modern device that I know of (S-ATA, SAS,
> SSD's and raid arrays should all handle this).

... and if the device is run out of all of its blocks in its spare
blocks pool, it's probably well past the time to replace said disk.

BTW, I really liked Dave Chinner's summary of the issues involved; I
ran into Kawai-san last week at Linux.conf.au, and we discussed pretty
much the same thing over lunch.  (i.e., that it's a hard problem, and
in some cases we need to retry the writes, such as a transient FC path
problem --- but some kind of write throttling is critical or we could
end up choking the VM due to too many pages getting dirtied and no way
of cleaning them.)

						- Ted
