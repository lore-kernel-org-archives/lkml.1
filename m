Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbXFYNWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbXFYNWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXFYNWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:22:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51049 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbXFYNWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:22:12 -0400
Date: Mon, 25 Jun 2007 09:19:17 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
Message-ID: <20070625131917.GD12852@think.oraclecorp.com>
References: <20070624014528.GA17609@wotan.suse.de> <20070624014613.GB17609@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624014613.GB17609@wotan.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 03:46:13AM +0200, Nick Piggin wrote:
> Rewrite the buffer layer.

Overall, I like the basic concepts, but it is hard to track the locking
rules.  Could you please write them up?

I like the way you split out the assoc_buffers from the main fsblock
code, but the list setup is still something of a wart.  It also provides
poor ordering of blocks for writeback.

I think it makes sense to replace the assoc_buffers list head with a
radix tree sorted by block number.  mark_buffer_dirty_inode would up the
reference count and put it into the radix, the various flushing routines
would walk the radix etc.

If you wanted to be able to drop the reference count once the block was
written you could have a back pointer to the appropriate inode.

-chris
