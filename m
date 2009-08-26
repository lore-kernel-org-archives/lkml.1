Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbZHZMXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbZHZMXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932746AbZHZMXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:23:47 -0400
Received: from THUNK.ORG ([69.25.196.29]:50241 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662AbZHZMXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:23:46 -0400
Date: Wed, 26 Aug 2009 08:23:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090826122311.GH32712@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
References: <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <4A9510D2.1090704@redhat.com> <20090826111208.GA26595@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826111208.GA26595@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 01:12:08PM +0200, Pavel Machek wrote:
> > I agree that this is not an interesting (or likely) scenario, certainly  
> > when compared to the much more frequent failures that RAID will protect  
> > against which is why I object to the document as Pavel suggested. It  
> > will steer people away from using RAID and directly increase their  
> > chances of losing their data if they use just a single disk.
> 
> So instead of fixing or at least documenting known software deficiency
> in Linux MD stack, you'll try to surpress that information so that
> people use more of raid5 setups?

First of all, it's not a "known software deficiency"; you can't do
anything about a degraded RAID array, other than to replace the failed
disk.  Secondly, what we should document is things like "don't use
crappy flash devices", "don't let the RAID array run in degraded mode
for a long time" and "if you must (which is a bad idea), better have a
UPS or a battery-backed hardware RAID".  What we should *not* document
is

"ext3 is worthless for RAID 5 arrays" (simply wrong)

and

"ext2 is better than ext3 because it forces you to run a long, slow
fsck after each boot, and that helps you to catch filesystem
corruptions when the storage devices goes bad" (Second part of the
statement is true, but it's still bad general advice, and it's
horribly misleading)

and

"ext2 and ext3 have this surprising dependency that disks act like
disks".  (alarmist)

      	       	    	 	    	       	    - Ted

