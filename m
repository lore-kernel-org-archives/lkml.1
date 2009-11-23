Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZKWNcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZKWNcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZKWNcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:32:16 -0500
Received: from lazybastard.de ([212.112.238.170]:46633 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZKWNcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:32:16 -0500
X-Greylist: delayed 985 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 08:32:15 EST
Date: Mon, 23 Nov 2009 14:32:15 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 5/17] [LogFS] dir.c
Message-ID: <20091123133214.GB18889@logfs.org>
References: <20091120181113.GA2159@logfs.org> <E1NBZIP-0003g2-0r@longford.logfs.org> <20091123111744.GA17527@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091123111744.GA17527@bicker>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 November 2009 13:17:44 +0200, Dan Carpenter wrote:
> On Fri, Nov 20, 2009 at 08:37:29PM +0100, Joern Engel wrote:
> > +static int logfs_unlink(struct inode *dir, struct dentry *dentry)
> > +{
> > +	struct logfs_super *super = logfs_super(dir->i_sb);
> > +	struct inode *inode = dentry->d_inode;
> > +	struct logfs_transaction *ta;
> > +	struct page *page;
> > +	pgoff_t index;
> > +	int ret;
> > +
> > +	ta = kzalloc(sizeof(*ta), GFP_KERNEL);
> > +	if (!ta)
> > +		return -ENOMEM;
> > +
> > +	ta->state = UNLINK_1;
> > +	ta->ino = inode->i_ino;
> > +
> > +	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> > +
> > +	page = logfs_get_dd_page(dir, dentry);
> > +	if (!page)
> 
> kfree(ta);
> 
> > +		return -ENOENT;
> > +	if (IS_ERR(page))
> 
> kfree(ta);
> 
> > +		return PTR_ERR(page);

Ick!  The drunkard who wrote that code ought to get fired.  Thank you
for noticing, Dan.

Fixed in the git tree.  And maybe I should go look for similar cases.

Jörn

-- 
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike
