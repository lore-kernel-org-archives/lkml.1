Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0BUCBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 21:01:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:32961 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab0BUCBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 21:01:51 -0500
Date: Sun, 21 Feb 2010 02:01:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH v2] vfs: add NOFOLLOW flag to umount(2)
Message-ID: <20100221020144.GV30031@ZenIV.linux.org.uk>
References: <E1NfAXx-0000ln-59@pomaz-ex.szeredi.hu>
 <20100211172100.GA28533@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211172100.GA28533@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 12:21:00PM -0500, Christoph Hellwig wrote:
> On Wed, Feb 10, 2010 at 12:15:53PM +0100, Miklos Szeredi wrote:
> >  - renamed flag to UMOUNT_NOFOLLOW
> >  - added UMOUNT_UNUSED for feature detection
> 
> Umm, why?  MNT_ certainly isn't the best naming for unmount flags,
> but switching convention after we had a few doesn't make any sense.

Actually, I've got more interesting question: what's being attempted
there?  Is that just a "let's protect ourselves against somebody feeding
us an untrusted symlink"?  I'm not sure if it makes much sense; if we
are dealing with pathnames on untrusted fs, there's nothing to stop the
attacker from having /mnt/foo/dir (originally containing a mountpoint
at /mnt/foo/dir/usr) killed and replaced with a symlink to /, making any
code that does umount() on such pathnames vulnerable as hell anyway.

Lack of LOOKUP_FOLLOW affects only the last pathname component.  So what
is that patch trying to make safe?
