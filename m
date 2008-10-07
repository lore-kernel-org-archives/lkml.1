Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYJGNhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYJGNhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYJGNhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:37:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbYJGNhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:37:15 -0400
Date: Tue, 7 Oct 2008 09:36:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Message-ID: <20081007133651.GA19895@infradead.org>
References: <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com> <20081006101605.GA15881@skywalker> <1223302903.16546.58.camel@think.oraclecorp.com> <20081007084531.GB15881@skywalker> <20081007090554.GA23811@infradead.org> <20081007100257.GA30745@skywalker> <20081007132911.GA6905@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007132911.GA6905@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 09:29:11AM -0400, Theodore Tso wrote:
> That's true, but there is a lot of code duplication, which means that
> bugs or changes in write_cache_pages() would need to be fixed in
> ext4_write_cache_pages().  So another approach that might be better
> from a long-term code maintenance point of view is to add a flag in
> struct writeback_control that tells write_cache_pages() not to update
> those fields, and avoid duplicating approximately 95 lines of code.
> It means a change in a core mm function, though, so if folks thinks
> its too ugly, we can make our own copy in fs/ext4.
> 
> Opinions?  Andrew, as someone who often weighs in on fs and mm issues,
> what do you think?  My preference would be to make the change to
> mm/page-writeback.c, controlled by a flag which ext4 would set be set
> by fs/ext4 before it calls write_cache_pages().

I agree.  But I'm still not quite sure if that requirement is unique to
ext4 anyway.  Give me some time to dive into the writeback code again,
haven't been there for quite a while.

