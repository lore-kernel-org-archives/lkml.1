Return-Path: <linux-kernel-owner+w=401wt.eu-S1763433AbZDCKfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433AbZDCKfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761770AbZDCKf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:35:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:8899 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761640AbZDCKf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P1OvN+LTf3GfRFmuE0oOhk58JRH/xs4ZemE9UvQdF4aHId3O9CT/V0pmBLc0/DdxxL
         ut7M4i/J2Jbh/oQMHiy+A3ICdovlZZQApWpH2ALQcC52M2J5yX3ZLkH+0kW47OPNS9Cn
         OIBZ6mUsQSUpKsc7wDObyR0M4mP45RMfG9EuE=
MIME-Version: 1.0
In-Reply-To: <20090401145041.6681fc90.akpm@linux-foundation.org>
References: <ea11fea30903222016j1d16372ct2dfd6004452e0531@mail.gmail.com> 
	<20090330163317.a273a46a.akpm@linux-foundation.org> <ea11fea30903301941p3a5a71c2l816df9a3d8341183@mail.gmail.com> 
	<20090401145041.6681fc90.akpm@linux-foundation.org>
Date: Fri, 3 Apr 2009 16:05:10 +0530
Message-ID: <ea11fea30904030335nd288a28ne3eb43ab7d8cabea@mail.gmail.com>
Subject: Re: [PATCH] : Add dev-id and inode number for debugging in 
	init_special_inode in fs/inode.c
From: Manish Katiyar <mkatiyar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org, adilger@sun.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 3:20 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 31 Mar 2009 08:11:00 +0530
> Manish Katiyar <mkatiyar@gmail.com> wrote:
>
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -1540,7 +1540,8 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
> >       else if (S_ISSOCK(mode))
> >               inode->i_fop = &bad_sock_fops;
> >       else
> > -             printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o)\n",
> > -                    mode);
> > +             printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
> > +                               " inode %s:%lu\n", mode, inode->i_sb->s_id,
> > +                               inode->i_ino);
> >  }
>
> Is ther a guarantee that inode->i_sb and inode->i_ino have been initialised
> at this time?

Hi Andrew,

I checked the code and most of the places we are trying to access
inode->i_sb , inode->i_ino before this function call or after this,
without any checks. So looks like we will have the values at this
point of time.

Thanks -
Manish
