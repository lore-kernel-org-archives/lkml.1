Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZALPL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZALPL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZALPLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:11:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46152 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZALPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:11:50 -0500
Date: Mon, 12 Jan 2009 10:11:33 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090112151133.GA24852@infradead.org>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
> Hi
> 
> I discovered a bug in XFS in delayed allocation.
> 
> When you take a small partition (52MB in my case) and copy many small 
> files on it (source code) that barely fits there, you get -ENOSPC. Then 
> sync the partition, some free space pops up, click "retry" in MC an the 
> copy continues. They you get again -ENOSPC, you must sync, click "retry" 
> and go on. And so on few times until the source code finally fits on the 
> XFS partition.
> 
> This misbehavior is apparently caused by delayed allocation, delayed 
> allocation does not exactly know how much space will be occupied by data, 
> so it makes some upper bound guess. Because free space count is only a 
> guess, not the actual data being consumed, XFS should not return -ENOSPC 
> on behalf of it. When the free space overflows, XFS should sync itself, 
> retry allocation and only return -ENOSPC if it fails the second time, 
> after the sync.

This looks a lot like: http://oss.sgi.com/bugzilla/show_bug.cgi?id=724
It's on my short-term todo list to turn the testcase in that entry
into a proper xfsqa testcase and followup on the investigation by
Dave and Eric.
