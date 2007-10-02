Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbXJBNFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbXJBNFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbXJBNFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:05:38 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52227 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbXJBNFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:05:37 -0400
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and
	read_inode()
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Zach Brown <zab@zabbo.net>, Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <11826.1191328350@redhat.com>
References: <963DCFBD-9E68-488E-BD2C-D8B751E65BDF@zabbo.net>
	 <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
	 <20071001130958.29339.31669.stgit@warthog.procyon.org.uk>
	 <20071001173930.GA7718@mami.zabbo.net>
	 <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org>
	 <20071001180601.GA9417@infradead.org>   <11826.1191328350@redhat.com>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 13:02:12 +0000
Message-Id: <1191330132.11136.2.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 13:32 +0100, David Howells wrote:
> Zach Brown <zab@zabbo.net> wrote:
> 
> > /* haha, continuing the fine tradition of terrible names in this  api..  */
> > static inline void *PTR_PTR(void *err_ptr) {
> > 	BUG_ON(!IS_ERR(err_ptr) || !err_ptr);
> > 	return err_ptr;
> > }
> 
> How about ERR_CAST() instead?  Or maybe CAST_ERR()?

It's a better name than PTR_PTR(). :-)
> 
> 	struct dentry *blah(...)
> 	{
> 		struct inode *inode;
> 
> 		inode = thing(...);
> 		if (IS_ERR(inode))
> 			return ERR_CAST(inode);
> 	}
> 
> Where ERR_CAST is defined as:
> 
> 	static inline void *ERR_CAST(const void *error)
> 	{
> 		return (void *) x;
> 	}

Of course, the cast is unnecessary, and I'm sure you meant to return
error:

static inline void *ERR_CAST(const void *error)
{
	return error;
}

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

