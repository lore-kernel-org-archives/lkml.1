Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbXFLQqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbXFLQqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbXFLQqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:46:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbXFLQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:46:39 -0400
Date: Tue, 12 Jun 2007 09:46:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: splice: move balance_dirty_pages_ratelimited() outside of   
 splice actor
Message-Id: <20070612094615.9e5557e5.akpm@linux-foundation.org>
In-Reply-To: <20070612124449.GD18832@kernel.dk>
References: <200706112159.l5BLxF5x004043@hera.kernel.org>
	<20070611163433.dbc541ec.akpm@linux-foundation.org>
	<20070612063510.GO18832@kernel.dk>
	<20070612112059.GY18832@kernel.dk>
	<20070612113101.GZ18832@kernel.dk>
	<1181649983.7348.309.camel@twins>
	<20070612121047.GB18832@kernel.dk>
	<1181650572.7348.312.camel@twins>
	<20070612124449.GD18832@kernel.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 14:44:50 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> splice

btw, I'm staring in profound mystification at this:

int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
			   struct pipe_buffer *buf)
{
	struct page *page = buf->page;

	if (page_count(page) == 1) {
		lock_page(page);
		return 0;
	}

	return 1;
}


afacit that `if page_count(page)' test could be replaced by
`if today_is_tuesday()'.  But then I don't have the foggiest idea
what it's trying to do.

It would be nice to get some comments in and around here.

Also, I was trying to work out the role and responsibility of the ->pin
callback, and gave up.

There isn't a lot of point in explaining this over email - one should be
able to gain an understanding of these things by reading the code.  I think
the best way of tackling this would be to comprehensively document
pipe_buf_operations and pipe_inode_info, please...


