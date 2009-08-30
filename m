Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZH3PVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZH3PVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 11:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZH3PVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 11:21:00 -0400
Received: from thunk.org ([69.25.196.29]:50970 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZH3PU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 11:20:59 -0400
Date: Sun, 30 Aug 2009 11:20:23 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090830152023.GB23828@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090830075135.GA1874@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 09:51:35AM +0200, Pavel Machek wrote:
> 
> If it only was this simple. We don't have 'check brakes' (aka
> 'journalling ineffective') warning light. If we had that, I would not
> have problem.

But we do; comptently designed (and in the cast of software RAID,
competently packaged) RAID subsystems send notifications to the system
administrator when there is a hard drive failure.  Some hardware RAID
systems will send a page to the system administrator.  A mid-range
Areca card has a separate ethernet port so it can send e-mail to the
administrator, even if the OS is hosed for some reason.

And it's not a matter of journalling ineffective; the much bigger deal
is, "your data is at risk"; perhaps because the file system metadata
may become subject to corruption, but more critically, because the
file data may become subject to corruption.  Metadata becoming subject
to corruption is important primarily because it leads to data becoming
corruption; metadata is the tail; the user's data is the dog.

So we *do* have the warning light; the problem is that just as some
people may not realize that "check brakes" means, "YOU COULD DIE",
some people may not realize that "hard drive failure; RAID array
degraded" could mean, "YOU COULD LOSE DATA".

Fortunately, for software RAID, this is easily solved; if you are so
concerned, why don't you submit a patch to mdadm adjusting the e-mail
sent to the system administrator when the array is in a degraded
state, such that it states, "YOU COULD LOSE DATA".  I would gently
suggest to you this would be ***far*** more effective that a patch to
kernel documentation.

						- Ted
