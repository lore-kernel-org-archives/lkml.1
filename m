Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZILNjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZILNjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 09:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZILNjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 09:39:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50955 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZILNjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 09:39:46 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Sep 2009 09:39:46 EDT
Date: Sat, 12 Sep 2009 14:39:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       akpm <akpm@linuxfoundation.org>
Subject: Re: mnt_want_write_file() has problem?
Message-ID: <20090912133944.GB5858@ZenIV.linux.org.uk>
References: <871vnt7vac.fsf@devron.myhome.or.jp> <1249413319.11056.131.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249413319.11056.131.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

[Very belated] ACK.
