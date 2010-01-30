Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102Ab0A3B71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0A3B71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 20:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521Ab0A3B71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 20:59:27 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:34347 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754868Ab0A3B70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 20:59:26 -0500
Date: Sat, 30 Jan 2010 12:59:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: buffer heads: Support slab defrag
Message-ID: <20100130015902.GI15853@discord.disaster>
References: <20100129204931.789743493@quilx.com> <20100129205003.813495196@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129205003.813495196@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 02:49:41PM -0600, Christoph Lameter wrote:
> Defragmentation support for buffer heads. We convert the references to
> buffers to struct page references and try to remove the buffers from
> those pages. If the pages are dirty then trigger writeout so that the
> buffer heads can be removed later.

NACK.

We don't want another random single page writeback trigger into
the VM - it will only slow down cleaning of dirty pages by causing
disk thrashing (i.e. turns writeback into small random write
workload), and that will ultimately slow down the rate at which we can
reclaim buffer heads.

Hence I suggest that if the buffer head is dirty, then just ignore
it - it'll be cleaned soon enough by one of the other mechanisms we
have and then it can be reclaimed in a later pass.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
