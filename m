Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbXJASGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbXJASGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXJASGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:06:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40992 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbXJASGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:06:08 -0400
Date: Mon, 1 Oct 2007 19:06:02 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zach Brown <zab@zabbo.net>, David Howells <dhowells@redhat.com>,
       hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and read_inode()
Message-ID: <20071001180601.GA9417@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Zach Brown <zab@zabbo.net>, David Howells <dhowells@redhat.com>,
	viro@ftp.linux.org.uk, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001130958.29339.31669.stgit@warthog.procyon.org.uk> <20071001173930.GA7718@mami.zabbo.net> <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 10:44:59AM -0700, Linus Torvalds wrote:
> > If you're soliciting opinions, I think I tend to prefer the feel of the
> > code paths after the changes.  I don't know the benefits of the change
> > are worth the risk in unmaintained file systems, though.
> > 
> > > +		return ERR_PTR(PTR_ERR(inode));
> > 
> > This caught my eye.  Surely we can do better :).  It seems to happen a
> > few times in the patches, the instance in this patch was the first that
> > I noticed.
> 
> Yeah. The above obviously *should* be the same as
> 
> 	return inode;
> 
> apart from a few casts. But if the casts matter, there's something else 
> wrong.

befs_lookup, which the above gem is from, returns a dentry *.

And given either

	return (dentry *)inode;

or
	return ERR_PTR(PTR_ERR(inode));

I tend to prefer the latter.
