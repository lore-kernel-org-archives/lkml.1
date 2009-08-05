Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZHEFhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZHEFhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZHEFhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:37:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:51241 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbZHEFhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:37:10 -0400
Date: Wed, 5 Aug 2009 07:37:05 +0200
From: Nick Piggin <npiggin@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       akpm <akpm@linuxfoundation.org>
Subject: Re: mnt_want_write_file() has problem?
Message-ID: <20090805053705.GA11060@wotan.suse.de>
References: <871vnt7vac.fsf@devron.myhome.or.jp> <1249413319.11056.131.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249413319.11056.131.camel@nimitz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 12:15:19PM -0700, Dave Hansen wrote:
> On Mon, 2009-08-03 at 06:36 +0900, OGAWA Hirofumi wrote:
> > diff -puN fs/namespace.c~mnt_want_write-wrong-assume fs/namespace.c
> > ---
> > linux-2.6/fs/namespace.c~mnt_want_write-wrong-assume        2009-08-03
> > 04:33:35.000000000 +0900
> > +++ linux-2.6-hirofumi/fs/namespace.c   2009-08-03 04:31:34.000000000
> > +0900
> > @@ -316,7 +316,8 @@ EXPORT_SYMBOL_GPL(mnt_clone_write);
> >   */
> >  int mnt_want_write_file(struct file *file)
> >  {
> > -       if (!(file->f_mode & FMODE_WRITE))
> > +       struct inode *inode = file->f_dentry->d_inode;
> > +       if (!(file->f_mode & FMODE_WRITE) || special_file(inode->i_mode))
> >                 return mnt_want_write(file->f_path.mnt);
> >         else
> >                 return mnt_clone_write(file->f_path.mnt);
> 
> I'm fine with this.  I'd like a debugging check in mnt_clone_write()
> since this bug is easy to detect, but such a check will also cost all of
> the performance gains that Nick added.  So, we can't have it
> unconditionally.

Yeah, good catch, thanks for this.

