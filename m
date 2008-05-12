Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYELAYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYELAYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 20:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYELAYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 20:24:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53101 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751560AbYELAYd (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 20:24:33 -0400
Date: Mon, 12 May 2008 10:24:03 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080512002403.GP103491721@sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510030916.935905242@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 08:08:41PM -0700, Christoph Lameter wrote:
> Defragmentation support for buffer heads. We convert the references to
> buffers to struct page references and try to remove the buffers from
> those pages. If the pages are dirty then trigger writeout so that the
> buffer heads can be removed later.

Oh, no, please don't trigger more random single page writeback from
memory reclaim.  We shoul dbe killing the VM's use of ->writepage,
not encouraging it.

If you are going to clean bufferheads (or pages), please clean entire
mappings via ->writepages as it leads to far superior I/O patterns
and a far higher aggregate rate of page cleaning.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
