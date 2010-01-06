Return-Path: <linux-kernel-owner+w=401wt.eu-S1751656Ab0AFFUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab0AFFUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 00:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193Ab0AFFUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 00:20:30 -0500
Received: from THUNK.ORG ([69.25.196.29]:40366 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab0AFFU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 00:20:29 -0500
Date: Wed, 6 Jan 2010 00:20:18 -0500
From: tytso@mit.edu
To: Greg KH <gregkh@suse.de>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 83/97] ext4: Fix potential quota deadlock
Message-ID: <20100106052018.GA29440@thunk.org>
Mail-Followup-To: tytso@mit.edu, Greg KH <gregkh@suse.de>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Dmitry Monakhov <dmonakhov@openvz.org>
References: <20100105003133.GA7199@kroah.com>
 <1262651630-7354-83-git-send-email-gregkh@suse.de>
 <20100105004741.GD3252@quack.suse.cz>
 <20100105185655.GB15630@suse.de>
 <20100105213927.GA3252@quack.suse.cz>
 <20100105231627.GA713@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105231627.GA713@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 03:16:27PM -0800, Greg KH wrote:
> On Tue, Jan 05, 2010 at 10:39:27PM +0100, Jan Kara wrote:
> > On Tue 05-01-10 10:56:55, Greg KH wrote:
> > > On Tue, Jan 05, 2010 at 01:47:42AM +0100, Jan Kara wrote:
> > > > On Mon 04-01-10 16:33:36, Greg Kroah-Hartman wrote:
> > > > > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > > > > 
> > > > > commit d21cd8f163ac44b15c465aab7306db931c606908 upstream.
> > > >   Ted has found a serious bug in this patch over Christmas and fixed it.
> > > > Ted, do you prefer to just discard this patch or will you add your fixes?
> > > Do you have the git commit id of the patch that fixes it?
> >   Commits fixing the behavior are:
> > 0637c6f4135f592f094207c7c21e7c0fc5557834
> > ee5f4d9cdf32fd99172d11665c592a288c2b1ff4
> > 9d0be50230b333005635967f7ecd4897dbfd181b
> 
> Hm, should I add these as well, or back out all of the ext4 quota
> patches from .32 and .31?

I don't think you need to back out all of the ext4 quota patches; Jan
has looked at the more carefully than I (since they went in via the
quota tree instead of the ext4 tree) but as far as I know the d21cd8f1
is a standalone fix and the other patches shouldn't break if you just
drop patch #83.  Adding the above mentioned patches is definitely
necessary if you include Patch #83, though, since otherwise people
mounting uncoverted ext3 filesystems using ext4 will get the BUG in
fs/ext4/inode.c:1063 regression.

As far as whether it would be better to drop patch #83 or to include
these three commits, it's a bit of a toss up.  If you want to play it
safe, I'd say let's drop it for now and wait for week or so, so we can
make sure the people who are testing -rc3 are happy, and for the next
stable release we can pick it up plus the additional commits listed
above.

Regards,

						- Ted
