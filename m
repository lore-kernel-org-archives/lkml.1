Return-Path: <linux-kernel-owner+w=401wt.eu-S932581Ab0AFS2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab0AFS2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547Ab0AFS2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:28:19 -0500
Received: from kroah.org ([198.145.64.141]:56490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510Ab0AFS2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:28:18 -0500
Date: Wed, 6 Jan 2010 10:27:18 -0800
From: Greg KH <greg@kroah.com>
To: tytso@mit.edu, Greg KH <gregkh@suse.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [stable] [PATCH 83/97] ext4: Fix potential quota deadlock
Message-ID: <20100106182718.GA27674@kroah.com>
References: <20100105003133.GA7199@kroah.com>
 <1262651630-7354-83-git-send-email-gregkh@suse.de>
 <20100105004741.GD3252@quack.suse.cz>
 <20100105185655.GB15630@suse.de>
 <20100105213927.GA3252@quack.suse.cz>
 <20100105231627.GA713@suse.de>
 <20100106052018.GA29440@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106052018.GA29440@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 12:20:18AM -0500, tytso@mit.edu wrote:
> On Tue, Jan 05, 2010 at 03:16:27PM -0800, Greg KH wrote:
> > On Tue, Jan 05, 2010 at 10:39:27PM +0100, Jan Kara wrote:
> > > On Tue 05-01-10 10:56:55, Greg KH wrote:
> > > > On Tue, Jan 05, 2010 at 01:47:42AM +0100, Jan Kara wrote:
> > > > > On Mon 04-01-10 16:33:36, Greg Kroah-Hartman wrote:
> > > > > > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > > > > > 
> > > > > > commit d21cd8f163ac44b15c465aab7306db931c606908 upstream.
> > > > >   Ted has found a serious bug in this patch over Christmas and fixed it.
> > > > > Ted, do you prefer to just discard this patch or will you add your fixes?
> > > > Do you have the git commit id of the patch that fixes it?
> > >   Commits fixing the behavior are:
> > > 0637c6f4135f592f094207c7c21e7c0fc5557834
> > > ee5f4d9cdf32fd99172d11665c592a288c2b1ff4
> > > 9d0be50230b333005635967f7ecd4897dbfd181b
> > 
> > Hm, should I add these as well, or back out all of the ext4 quota
> > patches from .32 and .31?
> 
> I don't think you need to back out all of the ext4 quota patches; Jan
> has looked at the more carefully than I (since they went in via the
> quota tree instead of the ext4 tree) but as far as I know the d21cd8f1
> is a standalone fix and the other patches shouldn't break if you just
> drop patch #83.  Adding the above mentioned patches is definitely
> necessary if you include Patch #83, though, since otherwise people
> mounting uncoverted ext3 filesystems using ext4 will get the BUG in
> fs/ext4/inode.c:1063 regression.
> 
> As far as whether it would be better to drop patch #83 or to include
> these three commits, it's a bit of a toss up.  If you want to play it
> safe, I'd say let's drop it for now and wait for week or so, so we can
> make sure the people who are testing -rc3 are happy, and for the next
> stable release we can pick it up plus the additional commits listed
> above.

Ok, I've dropped this patch from both the .31 and .32 -stable queues,
thanks.

Jan, want to resend this patch, along with the needed fixes, for the
next round of -stable releases when you get a chance, to
stable@kernel.org?

thanks,

greg k-h
