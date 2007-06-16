Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbXFPQrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbXFPQrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 12:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXFPQri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 12:47:38 -0400
Received: from pat.uio.no ([129.240.10.15]:56924 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbXFPQrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 12:47:37 -0400
Subject: Re: [PATCH] NFS: Make NFS root work again
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070616091514.8e5dc1d3.akpm@linux-foundation.org>
References: <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com>
	 <20070616091514.8e5dc1d3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 12:47:30 -0400
Message-Id: <1182012450.26143.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.082)
X-UiO-Scanned: 60AEB12DC88AADCB4C3910512D0F367850F224B1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 249 total 2406681 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-16 at 09:15 -0700, Andrew Morton wrote:
> On Thu, 07 Jun 2007 17:40:03 +0100 David Howells <dhowells@redhat.com> wrote:
> 
> > Make NFS root work by creating a "/root" directory to satisfy the mount,
> > otherwise the path lookup for the mount fails with ENOENT.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > ---
> > 
> >  init/do_mounts.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/init/do_mounts.c b/init/do_mounts.c
> > index 46fe407..967b852 100644
> > --- a/init/do_mounts.c
> > +++ b/init/do_mounts.c
> > @@ -270,7 +270,10 @@ static void __init get_fs_names(char *page)
> >  
> >  static int __init do_mount_root(char *name, char *fs, int flags, void *data)
> >  {
> > -	int err = sys_mount(name, "/root", fs, flags, data);
> > +	int err;
> > +
> > +	sys_mkdir("/root", 0755);
> > +	err = sys_mount(name, "/root", fs, flags, data);
> >  	if (err)
> >  		return err;
> 
> Am still awaiting a proper description of this patch, please.
> 
> What is not working, and how does this patch fix it?
> 
> I am unaware of any open bug reports against NFS root.

I'm confused too. We never used to require that the kernel create a
special /root directory. What changed, and when?

Trond

