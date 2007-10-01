Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbXJASjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbXJASjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbXJASjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:39:13 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:36273 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbXJASjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:39:12 -0400
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2007 14:39:12 EDT
In-Reply-To: <20071001180601.GA9417@infradead.org>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001130958.29339.31669.stgit@warthog.procyon.org.uk> <20071001173930.GA7718@mami.zabbo.net> <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org> <20071001180601.GA9417@infradead.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <963DCFBD-9E68-488E-BD2C-D8B751E65BDF@zabbo.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and read_inode()
Date: Mon, 1 Oct 2007 11:18:21 -0700
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 	return ERR_PTR(PTR_ERR(inode));
>
> I tend to prefer the latter.

It seems like a pretty noisy way to get a (void *) cast :/.  Maybe a  
function that has the cast but makes sure it's only used for IS_ERR()  
pointers?

/* haha, continuing the fine tradition of terrible names in this  
api..  */
static inline void *PTR_PTR(void *err_ptr) {
	BUG_ON(!IS_ERR(err_ptr) || !err_ptr);
	return err_ptr;
}

Meh.

- z
