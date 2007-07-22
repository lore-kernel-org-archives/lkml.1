Return-Path: <linux-kernel-owner+w=401wt.eu-S1762570AbXGVIh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762570AbXGVIh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbXGVIhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:37:11 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:64701 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754449AbXGVIhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:37:08 -0400
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on
	memory size
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
In-Reply-To: <20070722082434.GR11657@kernel.dk>
References: <20070721210005.000228000@chello.nl>
	 <20070721210052.497469000@chello.nl>  <20070722082434.GR11657@kernel.dk>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 10:36:45 +0200
Message-Id: <1185093405.20032.205.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 10:24 +0200, Jens Axboe wrote:
> On Sat, Jul 21 2007, Peter Zijlstra wrote:

> > +static __init int readahead_init(void)
> > +{
> > +	/*
> > +	 * Scale the max readahead window with system memory
> > +	 *
> > +	 *   64M:   128K
> > +	 *  128M:   180K
> > +	 *  256M:   256K
> > +	 *  512M:   360K
> > +	 *    1G:   512K
> > +	 *    2G:   724K
> > +	 *    4G:  1024K
> > +	 *    8G:  1448K
> > +	 *   16G:  2048K
> > +	 */
> > +	ra_pages = int_sqrt(totalram_pages/16);
> > +	if (ra_pages > (2 << (20 - PAGE_SHIFT)))
> > +		ra_pages = 2 << (20 - PAGE_SHIFT);
> > +
> > +	return 0;
> > +}
> 
> How did you come up with these numbers?

Well, most other places in the kernel where we scale by memory size we
use the a sqrt curve, and the specific scale was the result of some
fiddling, these numbers looked sane to me, nothing special.

Would you suggest a different set, and if so, do you have any rationale
for them?

