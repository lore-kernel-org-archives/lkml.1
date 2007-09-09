Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbXIIWAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbXIIWAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 18:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXIIWAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 18:00:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbXIIWAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 18:00:05 -0400
Date: Sun, 9 Sep 2007 14:59:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-Id: <20070909145940.0b41c8a5.akpm@linux-foundation.org>
In-Reply-To: <20070909203920.GA11764@infradead.org>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 21:39:20 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Sep 09, 2007 at 10:25:28PM +0200, Adrian Bunk wrote:
> > sys_{open,read} can finally be unexported.
> 
> Andrew, can you please put this in?  Having these exports for syscalls around
> hsa been a long-time annoyance that can finally be fixed now.

Sure.  But I think it is better to give people some warning when we're
planning on breaking out-of-tree things.  I do occasionally receive reports
of "hey, the X driver which I get from Y doesn't work any more".  Often
it's open-source stuff, too.  I see no point in irritating our users more than
we need to.

If we're changing an API or removing a function then there's nothing we can
do, but in the case where we're simply deleting an export, it's exceedingly
easy for us to EXPORT_UNUSED_SYMBOL (and __deprecated_for_modules?) for a
few months.

Adrian knows this, yet he habitually sends zero-warning export-removal
patches and I habitually ignore them.  I guess we must both enjoy this or
something.
