Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYLBQ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYLBQ4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYLBQ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:56:14 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43060 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510AbYLBQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:56:14 -0500
Date: Tue, 2 Dec 2008 11:56:08 -0500
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: SD/MMC cards: how crappy they are?
Message-ID: <20081202165608.GD18162@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20081202144830.GB1549@ucw.cz> <493562A5.40308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493562A5.40308@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 08:30:29AM -0800, H. Peter Anvin wrote:
> > ...maybe it was because of powerfail? I'll try to run badblocks to
> > recover it...
> > 
> > ...I did. Badblocks did not help, but cat /dev/zero > /dev/mmc1
> > did.. And yes, thosse 'temporarily bad blocks' seem very much
> > powerfail related.
> > 
> 
> Power failures can, indeed, do nasty things to SD/MMC cards, especially
> power rail sag in the middle of writes.

If this is your random eject out from your HP laptop problem, note
that random ejects while the card is writing can cause corruption of
the flash translation layer (FTL), which for some really crappy cards,
can permanently damage them; hopefully most of those are gone from the
market, but I wouldn't be positive about that.  The better ones will
have some kind of journalling scheme for their FTL...

Fsck does have a force rewrite option, although it's not the default.
You have to answer "n" to ignore error, and then yes to "force
rewrite".  I should perhaps change that; my worry at the time was a
transient read error tricking e2fsck into blowing away the contents of
what was actually a good sector.  Of course, that will only help
blocks which fsck actually tried reading; it won't help data blocks.

Badblocks -n will fix the problem, since it will do a non-destructive
read/write test over the entire disk.  Patches to add an
forced-rewrite mode to the standard r/o badblocks sweep (so we only
write to a sector that has a read error) would be gratefully accepted.

						- Ted


