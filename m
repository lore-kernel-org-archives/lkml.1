Return-Path: <linux-kernel-owner+w=401wt.eu-S933625AbZLPMes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbZLPMes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 07:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933117AbZLPMer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 07:34:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:34375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbZLPMeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 07:34:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="223492009"
Date: Wed, 16 Dec 2009 20:33:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Alex Chiang <achiang@hp.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm: introduce dump_page() and print symbolic flag names
Message-ID: <20091216123310.GA17522@localhost>
References: <20091216122640.GA13817@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216122640.GA13817@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:26:40PM +0800, Wu Fengguang wrote:
> - introduce dump_page() to print the page info for debugging some error condition.
> - convert three mm users: bad_page(), print_bad_pte() and memory offline failure. 
> - print an extra field: the symbolic names of page->flags
> 
> Example dump_page() output:
> 
> [  157.521694] page:ffffea0000a7cba8 count:2 mapcount:1
> mapping:ffff88001c901791 index:147
                                 ~~~ this is in fact 0x147

The index value may sometimes be misread as decimal number, shall this
be fixed by adding a "0x" prefix?

> [  157.525570] page flags: 100000000100068(uptodate|lru|active|swapbacked)
