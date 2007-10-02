Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbXJBNRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbXJBNRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbXJBNRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:17:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbXJBNRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:17:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071002102401.GB25647@atrey.karlin.mff.cuni.cz>
References: <20071002102401.GB25647@atrey.karlin.mff.cuni.cz> <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001131023.29339.51838.stgit@warthog.procyon.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: dhowells@redhat.com, hch@infradead.org, viro@ftp.linux.org.uk,
       torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/30] IGET: Stop EXT3 from using iget() and read_inode()
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 02 Oct 2007 14:16:59 +0100
Message-ID: <24599.1191331019@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> wrote:

>   But if you 'goto out' in some branches, we loose the ext3_warning()
> which we probably don't want.

Ugh.  Okay, I need to rework the changes to that function.

> >  			return ERR_PTR(-EACCES);
>   Wouldn't here -EIO be more appropriate?

I would have thought so, but -EACCES was what it returned before I touched it.
OTOH, it's calling ext3_error(), so EIO ought to be the right thing to do.
I'll alter it and see if anyone complains.

>   Why don't we use PTR_ERR() always? Is there some reason not to return
> -EIO?

I do wonder why it used to return EINVAL rather than EIO.  It's understandable
if the magic number doesn't match, but if it appears to be an otherwise
corrupt filesystem, then yes, I guess it should return EIO.  I'll change it.

David
