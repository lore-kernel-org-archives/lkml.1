Return-Path: <linux-kernel-owner+w=401wt.eu-S1763853AbYHDVLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763853AbYHDVLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763607AbYHDVK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:10:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46902 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbYHDVKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:10:23 -0400
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebmunson@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net,
       abh@cray.com
In-Reply-To: <20080731103137.GD1704@csn.ul.ie>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	 <20080730014308.2a447e71.akpm@linux-foundation.org>
	 <20080730172317.GA14138@csn.ul.ie>
	 <20080730103407.b110afc2.akpm@linux-foundation.org>
	 <20080730193010.GB14138@csn.ul.ie>
	 <20080730130709.eb541475.akpm@linux-foundation.org>
	 <20080731103137.GD1704@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 14:10:11 -0700
Message-Id: <1217884211.20260.144.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 11:31 +0100, Mel Gorman wrote:
> We are a lot more reliable than we were although exact quantification is
> difficult because it's workload dependent. For a long time, I've been able
> to test bits and pieces with hugepages by allocating the pool at the time
> I needed it even after days of uptime. Previously this required a reboot.

This is also a pretty big expansion of fs/hugetlb/ use outside of the
filesystem itself.  It is hacking the existing shared memory
kernel-internal user to spit out effectively anonymous memory.

Where do we draw the line where we stop using the filesystem for this?
Other than the immediate code reuse, does it gain us anything?

I have to think that actually refactoring the filesystem code and making
it usable for really anonymous memory, then using *that* in these
patches would be a lot more sane.  Especially for someone that goes to
look at it in a year. :)

-- Dave

