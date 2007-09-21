Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbXIUMnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbXIUMnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXIUMn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:43:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49389 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXIUMnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:43:25 -0400
Date: Fri, 21 Sep 2007 13:43:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
Message-ID: <20070921124323.GA8088@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921123333.247493758@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 02:23:46PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Pass the open file into the filesystem's *xattr() methods.
> 
> This is needed to be able to correctly implement open-unlink-f*xattr
> semantics, without having to resort to "silly-renaming".
> 
> Do this by adding a 'struct file *' parameter to i_op->*xattr().  For
> f... variants pass the open file pointer, in other cases pass NULL.
> 
> This is safe from a compatibility standpoint, out-of-tree old stuff
> will continue to work, but will get a warning at compile time.

NACK, no more optional arguments, and passing file structs to xattr
stuff is silly.  If your filesystem doesn't get open but unliked
right you will have to resort to silly renaming, I'm sorry.

Same argument applies to all pass file down patches in the series,
I won't comment on the separately.

