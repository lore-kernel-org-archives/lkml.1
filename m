Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbYJCTwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbYJCTwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYJCTwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:52:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56926 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYJCTwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:52:34 -0400
Subject: Re: [PATCH] Improve buffered streaming write ordering
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <20081002234309.GH30001@disturbed>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	 <20081001215239.ee2ae63f.akpm@linux-foundation.org>
	 <1222950054.6745.18.camel@think.oraclecorp.com>
	 <20081002181856.GB29613@skywalker>  <20081002234309.GH30001@disturbed>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 15:45:55 -0400
Message-Id: <1223063155.13375.64.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 09:43 +1000, Dave Chinner wrote:
> On Thu, Oct 02, 2008 at 11:48:56PM +0530, Aneesh Kumar K.V wrote:
> > On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > > For a 4.5GB streaming buffered write, this printk inside
> > > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > > 
> > 
> > Part of that can happen due to shrink_page_list -> pageout -> writepagee
> > call back with lots of unallocated buffer_heads(blocks).
> 
> Quite frankly, a simple streaming buffered write should *never*
> trigger writeback from the LRU in memory reclaim.

The blktrace runs on ext4 didn't show kswapd doing any IO.  It isn't
clear if this is because ext4 did the redirty trick or if kswapd didn't
call writepage.

-chris


