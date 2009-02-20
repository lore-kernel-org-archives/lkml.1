Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZBTVvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZBTVvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZBTVvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:51:08 -0500
Received: from THUNK.ORG ([69.25.196.29]:51509 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZBTVvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:51:06 -0500
Date: Fri, 20 Feb 2009 12:59:00 -0500
From: Theodore Tso <tytso@mit.edu>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, sct@redhat.com,
       akpm@linux-foundation.org, adilger@sun.com
Subject: Re: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory
	traversal through deleted inode
Message-ID: <20090220175900.GA18522@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bryan Donlan <bdonlan@gmail.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com
References: <20090214141411.GD26628@mini-me.lan> <1234833003-19631-1-git-send-email-bdonlan@gmail.com> <3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 12:53:39PM -0500, Bryan Donlan wrote:
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

It's already been pulled into akpm's tree as separate patches.  I'll
fix up the ext4 one by hand; probably better for you to send
replacement patches for ext3 separately to akpm and ask him to replace.

I'd suggest using __FUNC__ instead of hard-coding the function name, BTW...

    	    	  	   	      		  - Ted

