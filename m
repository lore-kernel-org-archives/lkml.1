Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbYEOON1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbYEOON1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYEOONP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:13:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54227 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYEOONP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:13:15 -0400
Date: Thu, 15 May 2008 10:13:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/9] fuse: add export operations
Message-ID: <20080515141311.GA14965@infradead.org>
References: <20080509124107.645600519@szeredi.hu> <20080509124133.577558326@szeredi.hu> <20080509194030.GA29118@infradead.org> <20080509194642.GA783@infradead.org> <E1JwdAj-0006ix-QP@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JwdAj-0006ix-QP@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 03:07:01PM +0200, Miklos Szeredi wrote:
> in i_ino.  This is not entirely trivial to fix: we either supply the
> inode numbers to the encoding function explicitly, or use something
> like the get_inode callback in generic_fh_to_dentry/_parent.  At which
> point I begin to doubt if it's worth the effort to share this code.
> After all the encoding/decoding functions are not complicated at all.

Doh, in that case using the generic encoce helper doesn't make any
sense.  decode doesn't care about i_ino, so it should be useable.  I'd
say go ahead with your fuse-local implementation for now, but please use
the 0x8n fh_type values.

