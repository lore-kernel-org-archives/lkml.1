Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbXEOVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbXEOVBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXEOVB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:01:29 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:54741 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbXEOVB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:01:28 -0400
Date: Tue, 15 May 2007 23:01:24 +0200
From: Johann Lombardi <johann@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
Message-ID: <20070515210124.GA23698@chiva>
Mail-Followup-To: Johann Lombardi <johann@clusterfs.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070515143726.GC2160@chiva> <20070515101144.f7072476.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515101144.f7072476.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 10:11:44AM -0700, Andrew Morton wrote:
> We need to make sure that this page has PG_uptodate cleared, so
> that a re-read is forced.  And the affected buffer_head, if any, should have
> buffer_uptodate() cleared.

ok.

> This change might have horrid interactions with readahead and various
> application access patterns: if for some reason a dud sector takes 30
> seconds of driver futzing to return -EIO and someone (application or
> kernel) tries to read the same sector tens or hundreds of times, suckiness
> ensues.  This will be hard to test for.

Yes, I agree. So according to you, what's the best way to address the
initial problem (i.e. PG_error never cleared)?

> Most reads don't (or shouldn't) go through block_read_full_page().
> mpage_readpages() does the heavy lifting.

Yes, indeed. However, as soon as a call to get_block() fails,
do_mpage_readpage() will call block_read_full_page() which will attach
buffers to this page.
Consequently, all subsequent reads will go through block_read_full_page().

Johann
