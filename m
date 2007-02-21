Return-Path: <linux-kernel-owner+w=401wt.eu-S1422787AbXBUSgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422787AbXBUSgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422786AbXBUSgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:36:54 -0500
Received: from pat.uio.no ([129.240.10.15]:59224 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422781AbXBUSgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:36:52 -0500
Subject: Re: [PATCH] update ctime and mtime for mmaped write
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, staubach@redhat.com, hugh@veritas.com,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HJwCl-0003V6-00@dorka.pomaz.szeredi.hu>
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu>
	 <1172081562.9108.1.camel@heimdal.trondhjem.org>
	 <E1HJwCl-0003V6-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 13:36:44 -0500
Message-Id: <1172083004.9108.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 893E2330BA43A4094A8921D3444D3CCFA45AA49A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 715 total 2817 max/h 1293 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 19:28 +0100, Miklos Szeredi wrote:
> > > This flag is checked in msync() and __fput(), and if set, the file
> > > times are updated and the flag is cleared
> > 
> > Why not also check inside vfs_getattr?
> 
> This is the minimum, that the standard asks for.
> 
> Note, your porposal would touch the times in vfs_getattr(), which
> means, that the modification times would depend on the time of the
> last stat() call, which is not really right, though it would still be
> conforming.
> 
> It is much saner, if the modification time is always the time of the
> last write() or msync().

I disagree. The above doesn't allow a program like 'make' to discover
whether or not the file has changed by simply calling stat(). Instead,
you're forcing a call to msync()+stat().

Cheers
  Trond

