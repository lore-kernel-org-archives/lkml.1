Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbYBIFJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbYBIFJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 00:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYBIFJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 00:09:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYBIFJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 00:09:13 -0500
Date: Sat, 9 Feb 2008 00:09:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, viro@ZenIV.linux.org.uk,
       viro@ftp.linux.org.uk, miklos@szeredi.hu
Subject: Re: [RFC][PATCH 06/30] make open_namei() return a filp
Message-ID: <20080209050910.GE1428@infradead.org>
References: <20080208222641.6024A7CC@kernel> <20080208222654.5DD25B27@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208222654.5DD25B27@kernel>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 02:26:54PM -0800, Dave Hansen wrote:
> 
> open_namei() will, in the future, need to take mount write counts
> over its creation and truncation (via may_open()) operations.  It
> needs to keep these write counts until any potential filp that is
> created gets __fput()'d.
> 
> This gets complicated in the error handling and becomes very murky
> as to how far open_namei() actually got, and whether or not that
> mount write count was taken.
> 
> Creating the filps inside of open_namei() lets us shift the write
> count to be taken and released along with the filp.  We can hold
> a temporary write count during those creation and truncation
> operations, then release them once the write for the filp has
> been established.
> 
> Any caller who gets a 'struct file' back must consider that filp
> instantiated and fput() it normally.  The callers no longer
> have to worry about ever manually releasing a mnt write count.

This patch description is not correct anymore, open_namei is actually
gone with this patch as it got merged into do_filp_open.

