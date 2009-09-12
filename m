Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZILPGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZILPGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZILPGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:06:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57982 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZILPGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:06:22 -0400
Date: Sat, 12 Sep 2009 16:06:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, hch@infradead.org
Subject: Re: [PATCH] fs: Make sure data stored into inode is properly seen
	before unlocking new inode
Message-ID: <20090912150625.GF5858@ZenIV.linux.org.uk>
References: <1252410063-26872-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252410063-26872-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 01:41:03PM +0200, Jan Kara wrote:
> In theory it could happen that on one CPU we initialize a new inode but clearing
> of I_NEW | I_LOCK gets reordered before some of the initialization. Thus on
> another CPU we return not fully uptodate inode from iget_locked().
> 
> This seems to fix a corruption issue on ext3 mounted over NFS.

Nice catch.  ACK.

>   Since Al doesn't seem to be online, does anybody else have opinion on this
> patch? I can merge it via my tree but I'd like to get a review from someone
> else.

I'm back, actually, and finally had almost crawled from under the pile
of mail in mbox.  Will apply.
