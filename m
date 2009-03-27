Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZC0XD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZC0XD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZC0XDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:03:46 -0400
Received: from THUNK.ORG ([69.25.196.29]:47593 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbZC0XDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:03:45 -0400
Date: Fri, 27 Mar 2009 19:03:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] ext3: Avoid starting a transaction in writepage
	when not necessary
Message-ID: <20090327230341.GF5176@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <1238185471-31152-3-git-send-email-tytso@mit.edu> <1238185471-31152-4-git-send-email-tytso@mit.edu> <20090327222346.GJ31071@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327222346.GJ31071@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 11:23:46PM +0100, Jan Kara wrote:
> On Fri 27-03-09 16:24:31, Theodore Ts'o wrote:
> > From: Jan Kara <jack@suse.cz>
> > 
> > We don't have to start a transaction in writepage() when all the blocks
> > are a properly allocated. Even in ordered mode either the data has been
> > written via write() and they are thus already added to transaction's list
> > or the data was written via mmap and then it's random in which transaction
> > they get written anyway.
> > 
> > This should help VM to pageout dirty memory without blocking on transaction
> > commits.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>   Please, use the patch below instead (and I'd also wait a few days for
> Mingo to check whether it also helps him). It also changes data=writeback
> mode in the same way and it adheres to coding style...

FYI, Looks like Linus has already cherry-picked your first patch from
LKML and dropped it into mainline.  My other two patches haven't gone
in yet as far as I can tell.

So we'll need to do a delta patch that has the differences from your
new patch and what Linus has already pulled into mainline.

    	      	   	     	     	    - Ted
