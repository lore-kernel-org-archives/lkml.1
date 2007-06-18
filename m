Return-Path: <linux-kernel-owner+w=401wt.eu-S1761584AbXFRR0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761584AbXFRR0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXFRR0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:26:37 -0400
Received: from THUNK.ORG ([69.25.196.29]:58227 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXFRR0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:26:37 -0400
Date: Mon, 18 Jun 2007 13:26:25 -0400
From: Theodore Tso <tytso@mit.edu>
To: Magnus Naeslund <mag@kite.se>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, linux-kernel@vger.kernel.org
Subject: Re: ARC-1260: No space left on device, when there is (or should be) free space left
Message-ID: <20070618172625.GA24189@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Magnus Naeslund <mag@kite.se>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	linux-kernel@vger.kernel.org
References: <4676679E.5040901@kite.se> <Pine.LNX.4.64.0706180730320.14972@localhost.localdomain> <4676787F.30609@kite.se> <20070618134413.GC30244@thunk.org> <4676B298.4080904@kite.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4676B298.4080904@kite.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 06:28:08PM +0200, Magnus Naeslund wrote:
> 
> It's a filesystem containing images varying from 300kb to 2mb of size.
> It currently contains 1426394 files in 4125 directories.
> 
> Magnus
> 
> Inode count:              1430528
> Block count:              1464843264
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         32

Well, *thar's* your problem!  :-)

I'm guessing you created the filesystem with mke2fs -T largefile4.
This basically told mke2fs that you anticipated the filesystem to have
an average inode size of 4 megabytes.  Given that your filesystem has
files ranging from 300k and 2mb, that's why you're running into
problems.

						- Ted
