Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbXJBMcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbXJBMcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXJBMco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:32:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbXJBMcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:32:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <963DCFBD-9E68-488E-BD2C-D8B751E65BDF@zabbo.net>
References: <963DCFBD-9E68-488E-BD2C-D8B751E65BDF@zabbo.net> <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001130958.29339.31669.stgit@warthog.procyon.org.uk> <20071001173930.GA7718@mami.zabbo.net> <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org> <20071001180601.GA9417@infradead.org> 
To: Zach Brown <zab@zabbo.net>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
       viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and read_inode()
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 02 Oct 2007 13:32:30 +0100
Message-ID: <11826.1191328350@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown <zab@zabbo.net> wrote:

> /* haha, continuing the fine tradition of terrible names in this  api..  */
> static inline void *PTR_PTR(void *err_ptr) {
> 	BUG_ON(!IS_ERR(err_ptr) || !err_ptr);
> 	return err_ptr;
> }

How about ERR_CAST() instead?  Or maybe CAST_ERR()?

	struct dentry *blah(...)
	{
		struct inode *inode;

		inode = thing(...);
		if (IS_ERR(inode))
			return ERR_CAST(inode);
	}

Where ERR_CAST is defined as:

	static inline void *ERR_CAST(const void *error)
	{
		return (void *) x;
	}

David
