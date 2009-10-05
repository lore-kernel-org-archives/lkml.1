Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZJEO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZJEO4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZJEO4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:56:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbZJEO4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:56:35 -0400
Date: Mon, 5 Oct 2009 16:55:57 +0200
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       sandeen@redhat.com
Subject: Re: [PATCH] ext3: Don't update superblock write time when
	filesystem is read-only
Message-ID: <20091005145557.GE8388@duck.suse.cz>
References: <1254625958-3588-1-git-send-email-tytso@mit.edu> <20091005122409.GC8388@duck.suse.cz> <20091005140118.GD13512@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005140118.GD13512@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-10-09 10:01:18, Theodore Tso wrote:
> On Mon, Oct 05, 2009 at 02:24:09PM +0200, Jan Kara wrote:
> > On Sat 03-10-09 23:12:38, Theodore Ts'o wrote:
> > > This avoids updating the superblock write time when we are mounting
> > > the root file system read/only but we need to replay the journal; at
> > > that point, for people who are east of GMT and who make their clock
> > > tick in localtime for Windows bug-for-bug compatibility, and this will
> > > cause e2fsck to complain and force a full file system check.
> >   Thanks, the patch is queued in my queue already. I just held it for a
> > while because Eric also had a valid point - maybe fsck is too strict when
> > it forces a full filesystem check just because the superblock write time is
> > in future? On a pc-class hw, clocks go often wrong. Even I remember setting
> > system clock on my desktop a few hours back because it just gets out of
> > sync and I don't run NTP...
> >   So I'm not against your patch because it can help in some cases and
> > it's not a big deal but I think a proper fix would be in fsck...
> 
> Regardless of whether fsck relaxes its check, if the filesystem is
> mounted read-only, I don't think the last write time should change...
  Yeah, that's also a reasonable argument, although in fact the filesystem
has changed (we replayed the journal) so I can also see a reason to keep
updating it.
  Anyway, as I said above, I'm not against the patch. I'll push it to Linus
this week.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
