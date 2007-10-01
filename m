Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbXJARpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbXJARpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXJARpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:45:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbXJARpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:45:35 -0400
Date: Mon, 1 Oct 2007 10:44:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zab@zabbo.net>
cc: David Howells <dhowells@redhat.com>, hch@infradead.org,
       viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and
 read_inode()
In-Reply-To: <20071001173930.GA7718@mami.zabbo.net>
Message-ID: <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
 <20071001130958.29339.31669.stgit@warthog.procyon.org.uk>
 <20071001173930.GA7718@mami.zabbo.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Oct 2007, Zach Brown wrote:
>
> If you're soliciting opinions, I think I tend to prefer the feel of the
> code paths after the changes.  I don't know the benefits of the change
> are worth the risk in unmaintained file systems, though.
> 
> > +		return ERR_PTR(PTR_ERR(inode));
> 
> This caught my eye.  Surely we can do better :).  It seems to happen a
> few times in the patches, the instance in this patch was the first that
> I noticed.

Yeah. The above obviously *should* be the same as

	return inode;

apart from a few casts. But if the casts matter, there's something else 
wrong.

		Linus
