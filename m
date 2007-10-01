Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbXJASUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbXJASUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXJASUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:20:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413AbXJASUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:20:23 -0400
Date: Mon, 1 Oct 2007 11:19:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Zach Brown <zab@zabbo.net>, David Howells <dhowells@redhat.com>,
       viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and
 read_inode()
In-Reply-To: <20071001180601.GA9417@infradead.org>
Message-ID: <alpine.LFD.0.999.0710011117570.3579@woody.linux-foundation.org>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
 <20071001130958.29339.31669.stgit@warthog.procyon.org.uk>
 <20071001173930.GA7718@mami.zabbo.net> <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org>
 <20071001180601.GA9417@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Oct 2007, Christoph Hellwig wrote:
> 
> befs_lookup, which the above gem is from, returns a dentry *.

Ahh, ok. Then it actually makes sense. Although I'd prefer it if people 
planned on writing code like that more along the lines of

	error = PTR_ERR(inode);
	if (IS_ERR(inode)
		return ERR_PTR(error);

because let's face it, the compiler can turn this into nice code, and 
humans can read it much better even if it's got an "unnecessary" extra 
variable etc..

			Linus
