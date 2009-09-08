Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbZIHSmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbZIHSmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZIHSm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:42:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZIHSm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:42:28 -0400
Date: Tue, 8 Sep 2009 14:42:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, hch@infradead.org
Subject: Re: [PATCH] fs: Make sure data stored into inode is properly seen
	before unlocking new inode
Message-ID: <20090908184229.GA5956@infradead.org>
References: <1252410063-26872-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252410063-26872-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 01:41:03PM +0200, Jan Kara wrote:
> In theory it could happen that on one CPU we initialize a new inode but clearing
> of I_NEW | I_LOCK gets reordered before some of the initialization. Thus on
> another CPU we return not fully uptodate inode from iget_locked().
> 
> This seems to fix a corruption issue on ext3 mounted over NFS.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good to me.  Impressive that this causes real life issues.

