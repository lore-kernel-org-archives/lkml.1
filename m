Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbZADTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbZADTcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbZADTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:31:52 -0500
Received: from thunk.org ([69.25.196.29]:60020 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbZADTbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:31:51 -0500
Date: Sun, 4 Jan 2009 14:31:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104193141.GA22958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <fa.b62zZFe5e154PhgA+0sdwVXD9F0@ifi.uio.no> <fa.ZTpiSvxEhp3YJDepiUQs+cU0C98@ifi.uio.no> <fa.xvvufQC6zTpU9R6vhDl51DR5V7A@ifi.uio.no> <fa.pkV69eXC76Pb9fnmERdAwXX9OKA@ifi.uio.no> <fa.hQTLXdIllf+hs4yQb092u6fowq0@ifi.uio.no> <49610911.8000204@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49610911.8000204@yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 07:08:01PM +0000, Sitsofe Wheeler wrote:
> Theodore Tso wrote:
>> So what's the use case where people want to be able to mount a
>> filesystem needing recovery read/only without running the journal?
>
> Corrupted SD card[1] that's been locked to read only for recovery  
> purposes without having the FS tear itself apart further?

In that case, the right answer is to copy the 32 GB SD card to hard
drive, and then operate on the hard drive.....  In general, if the
media has started going bad, the *first* thing you want to do is an
immediate copy of the media to some place stable.

> Others seem to be saying that it is useful for forensics...

Again, the best thing to do is a full image copy of the drive before
you do anything else.....

If someone wants to implement code to scans the journal, and create a
redirection map where whenever the filesystem needs to read from block
N, it reads from block M instead, they should feel free to do so.  But
so far, each of the use cases people are talking about are pretty rare
cases, which is probably why we don't have it at moment.

In fact, it's probably possible to create this as a pure userspace
solution using devicemapper.

	 					- Ted
