Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZGGPIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZGGPIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZGGPIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:08:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZGGPH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:07:59 -0400
Date: Tue, 7 Jul 2009 11:07:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090707150758.GA18075@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144823.GE2714@wotan.suse.de> <20090707145820.GA9976@infradead.org> <20090707150257.GG2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707150257.GG2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 05:02:57PM +0200, Nick Piggin wrote:
> That's kind of why I liked it in inode_setattr better.
> 
> But if the filesystem defines its own ->setattr, then it could simply
> not define a ->setsize and do the right thing in setattr. So this
> calling convention seems not too bad.

Or the filesystem could just call into it's own setattr method
internally.  For that we'd switch back to passing the iattr to
->setsize.  For a filesystem that doesn't do anything special for
ATTR_SIZE ->setsize could point to the same function as ->setattr.

For filesystem where's it's really different they could be separate or
share helpers.

