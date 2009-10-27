Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbZJ0VWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbZJ0VWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932369AbZJ0VWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312AbZJ0VW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:22:29 -0400
Date: Tue, 27 Oct 2009 17:22:06 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 10/41] whiteout: Add vfs_whiteout() and whiteout inode operation
Message-ID: <20091027212205.GB2132@shell>
References: <1256152779-10054-3-git-send-email-vaurora@redhat.com> <1256152779-10054-4-git-send-email-vaurora@redhat.com> <1256152779-10054-5-git-send-email-vaurora@redhat.com> <1256152779-10054-6-git-send-email-vaurora@redhat.com> <1256152779-10054-7-git-send-email-vaurora@redhat.com> <1256152779-10054-8-git-send-email-vaurora@redhat.com> <1256152779-10054-9-git-send-email-vaurora@redhat.com> <1256152779-10054-10-git-send-email-vaurora@redhat.com> <1256152779-10054-11-git-send-email-vaurora@redhat.com> <7e0fb38c0910270736h13860a3ckf2690a76f99b35be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e0fb38c0910270736h13860a3ckf2690a76f99b35be@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 10:36:18AM -0400, Eric Paris wrote:
> On Wed, Oct 21, 2009 at 3:19 PM, Valerie Aurora <vaurora@redhat.com> wrote:
> > From: Jan Blunck <jblunck@suse.de>
> >
> > Simply white-out a given directory entry. This functionality is usually used
> > in the sense of unlink. Therefore the given dentry can still be in-use and
> > contains an in-use inode. The filesystems inode operation has to do what
> > unlink or rmdir would in that case. Since the dentry still might be in-use
> > we have to provide a fresh unhashed dentry that is used as the whiteout
> > dentry instead. The given dentry is dropped and the whiteout dentry is
> > rehashed instead.
> >
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> > ?fs/dcache.c ? ? ? ? ? ?| ? ?4 +-
> > ?fs/namei.c ? ? ? ? ? ? | ?104 ++++++++++++++++++++++++++++++++++++++++++++++++
> > ?include/linux/dcache.h | ? ?6 +++
> > ?include/linux/fs.h ? ? | ? ?3 +
> > ?4 files changed, 116 insertions(+), 1 deletions(-)
> >
> 
> > diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> > index 30b93b2..7648b49 100644
> > --- a/include/linux/dcache.h
> > +++ b/include/linux/dcache.h
> > @@ -183,6 +183,7 @@ d_iput: ? ? ? ? ? ? no ? ? ? ? ? ? ?no ? ? ? ? ? ? ?no ? ? ? yes
> > ?#define DCACHE_INOTIFY_PARENT_WATCHED ?0x0020 /* Parent inode is watched by inotify */
> >
> > ?#define DCACHE_COOKIE ? ? ? ? ?0x0040 ?/* For use by dcookie subsystem */
> > +#define DCACHE_WHITEOUT ? ? ? ? ? ? ? ?0x0080 ?/* This negative dentry is a whiteout */
> >
> > ?#define DCACHE_FSNOTIFY_PARENT_WATCHED 0x0080 /* Parent inode is watched by some fsnotify listener */
> >
> 
> I don't think you want 2 flags with the 0x0080 value.......   This
> can't be right.

This looks like a merge error I introduced during a rebase.  Thanks
for catching it!

-VAL
