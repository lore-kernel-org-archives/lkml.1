Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYJBXn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYJBXn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYJBXnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:43:16 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:52536 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbYJBXnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:43:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkDAN/25Eh5LF82iGdsb2JhbACTWgEBARUiqVSBag
X-IronPort-AV: E=Sophos;i="4.33,353,1220193000"; 
   d="scan'208";a="219301218"
Date: Fri, 3 Oct 2008 09:43:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Message-ID: <20081002234309.GH30001@disturbed>
Mail-Followup-To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002181856.GB29613@skywalker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 11:48:56PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > For a 4.5GB streaming buffered write, this printk inside
> > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > 
> 
> Part of that can happen due to shrink_page_list -> pageout -> writepagee
> call back with lots of unallocated buffer_heads(blocks).

Quite frankly, a simple streaming buffered write should *never*
trigger writeback from the LRU in memory reclaim. That indicates
that some feedback loop has broken down and we are not cleaning
pages fast enough or perhaps in the correct order. Page reclaim in
this case should be reclaiming clean pages (those that have already
been written back), not writing back random dirty pages.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
