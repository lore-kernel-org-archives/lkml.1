Return-Path: <linux-kernel-owner+w=401wt.eu-S1030803AbXDLXl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030803AbXDLXl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030805AbXDLXl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:41:57 -0400
Received: from holomorphy.com ([66.93.40.71]:35604 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030803AbXDLXl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:41:56 -0400
Date: Thu, 12 Apr 2007 16:42:09 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070412234209.GO2986@holomorphy.com>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412163235.dd030637.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 16:10:50 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> This solves a real-life problem for Oracle system monitoring software
>> (specifically EM). Among the tasks it must carry out is determining
>> per-process memory footprint of a set of cooperating tasks (i.e. Oracle
>> processes). RSS is inadequate for this due to page sharing; this work
>> provides sufficient information to determine what EM needs.

On Thu, Apr 12, 2007 at 04:32:35PM -0700, Andrew Morton wrote:
> Not a good idea to expose raw flags in this manner - it changes at the drop
> of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
> mapping to make this viable.
> Not a good idea to use page->_count: page_count() will be more stable. 
> Otherwise OK, I guess: the interpretation of the page refcount is unlikely
> to change much over time.

EM wants to determine page_mapcount() for the most part for the
purposes of determining "uniquely attributable RSS" (my ca. 2004
nomenclature) or "proportional RSS" (mpm's more recent nomenclature);
as things now stand it will have to infer them by maintaining a table
of pfn's and mappings thereof, but at least that can be done with it.


-- wli
