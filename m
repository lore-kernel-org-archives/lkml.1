Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbXFLEry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbXFLEry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 00:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXFLErr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 00:47:47 -0400
Received: from holomorphy.com ([66.93.40.71]:59243 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbXFLErr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 00:47:47 -0400
Date: Mon, 11 Jun 2007 21:48:55 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, dean gaudet <dean@arctic.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, clameter@sgi.com
Subject: Re: [shm][hugetlb] Fix get_policy for stacked shared memory files
Message-ID: <20070612044855.GD11781@holomorphy.com>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org> <20070516061259.GZ19966@holomorphy.com> <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org> <1181597696.22671.2.camel@localhost.localdomain> <20070611213020.b3d91757.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611213020.b3d91757.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 09:30:20PM -0700, Andrew Morton wrote:
> Can we just double-check the refcounting please?

The refcounting for mpol's doesn't look good in general. I'm more
curious as to what releases the refcounts. alloc_page_vma(), for
instance, does get_vma_policy() which eventually takes a reference,
without ever releasing the reference it acquires. get_vma_policy()
itself uses a similar idiom to that used in aglitke's patch. I think
mpol refcounting needs to be addressed elsewhere besides this patch.


-- wli
