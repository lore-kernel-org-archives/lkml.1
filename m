Return-Path: <linux-kernel-owner+w=401wt.eu-S1765425AbZAQXDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765425AbZAQXDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbZAQXD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:03:26 -0500
Received: from THUNK.ORG ([69.25.196.29]:41912 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925AbZAQXD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:03:26 -0500
Date: Sat, 17 Jan 2009 18:03:22 -0500
From: Theodore Tso <tytso@mit.edu>
To: Malte =?iso-8859-1?Q?Schr=F6der?= <maltesch@gmx.de>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: ext4-stable build failure (Re: Ext4 tree backports for
	2.6.27.10 and 2.6.28)
Message-ID: <20090117230322.GA25943@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Malte =?iso-8859-1?Q?Schr=F6der?= <maltesch@gmx.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
References: <E1LOG9D-0006h4-7R@closure.thunk.org> <20090117231651.78b2cce5@highlander.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090117231651.78b2cce5@highlander.home.lan>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 11:16:51PM +0100, Malte Schröder wrote:
> 
> kernel 2.6.28 with ext4-stable fails to build for SMP on AMD64.
> 
> Building modules, stage 2.
> MODPOST 905 modules
> ERROR: "inode_lock" [fs/ext4/ext4.ko] undefined!
> 
> I had to revert 5cb8613e44b6e6c77dcf231d691b96c91a5adeab (ext4: Add a
> delayed allocation debugging ioctl), after that it works.

I see the problem; inode_lock isn't currently an exported symbol, and
I generally don't compile ext4 as a module, so I didn't notice the
problem.  The patch in question is a debugging patch that is never
meant for mainline or a for-stable series, so the simplest thing to do
for now is just to revert the patch.  I'll look into a module-friendly
way of accomplishing the same goal.

Regards,

						- Ted
