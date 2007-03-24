Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXCXHkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXCXHkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 03:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXCXHkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 03:40:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60584 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXCXHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 03:40:38 -0400
Date: Sat, 24 Mar 2007 07:40:30 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ken Chen <kenchen@google.com>
Cc: Adam Litke <agl@us.ibm.com>, William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] hugetlb: add resv argument to hugetlb_file_setup
Message-ID: <20070324074030.GA18408@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ken Chen <kenchen@google.com>, Adam Litke <agl@us.ibm.com>,
	William Lee Irwin III <wli@holomorphy.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <b040c32a0703231542r77030723o214255a5fa591dec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0703231542r77030723o214255a5fa591dec@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 03:42:13PM -0700, Ken Chen wrote:
> rename hugetlb_zero_setup() to hugetlb_file_setup() to better match
> function name convention like shmem implementation.  Also add an
> argument to the function to indicate whether file setup should reserve
> hugetlb page upfront or not.

I think the reservation call should be move out of this function entirely.
We only return the file descriptors through the syscall we're in, and
the dentries never appear in any namespace, so there is not reason to
do the reservation early.

