Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZBTS0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZBTS0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZBTS0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:26:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbZBTS0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:26:06 -0500
Date: Fri, 20 Feb 2009 10:25:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, sct@redhat.com,
       adilger@sun.com, tytso@mit.edu
Subject: Re: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory 
 traversal through deleted inode
Message-Id: <20090220102508.fc4e1feb.akpm@linux-foundation.org>
In-Reply-To: <3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
References: <20090214141411.GD26628@mini-me.lan>
	<1234833003-19631-1-git-send-email-bdonlan@gmail.com>
	<3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 12:53:39 -0500 Bryan Donlan <bdonlan@gmail.com> wrote:

> On Mon, Feb 16, 2009 at 8:10 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
> 
> > +               if (unlikely(IS_ERR(inode))) {
> > +                       if (PTR_ERR(inode) == -ESTALE) {
> > +                               ext3_error(dir->i_sb, "ext2_lookup",
> > +                                               "deleted inode referenced: %lu",
> > +                                               ino);
> > +                               return ERR_PTR(-EIO);
> > +                       } else {
> > +                               return ERR_CAST(inode);
> > +                       }
> > +               }
> 
> I just noticed that I forgot to edit the function name in the
> ext3_error and ext4_error invocations... Would it be better to send a
> delta to fix this or resubmit the whole thing?

I just edited the diffs on my copies - switched all three to __func__.
