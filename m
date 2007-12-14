Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbXLNS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbXLNS6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXLNS6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:58:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41133 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXLNS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:58:36 -0500
Subject: Re: [PATCH] dio: falling through to buffered I/O when invalidation
	of a page fails
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <475F32B0.20107@oracle.com>
References: <6.0.0.20.2.20071210164242.03915ca8@172.19.0.2>
	 <475F32B0.20107@oracle.com>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 10:59:56 -0800
Message-Id: <1197658796.12368.1.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-11 at 17:00 -0800, Zach Brown wrote:
> Hisashi Hifumi wrote:
> > Hi.
> > 
> > Current dio has some problems:
> > 1, In ext3 ordered, dio write can return with EIO because of the race
> > between invalidation of
> > a page and jbd. jbd pins the bhs while committing journal so
> > try_to_release_page fails when jbd
> > is committing the transaction.
> 
> Yeah.  It sure would be fantastic if some ext3 expert could stop this
> from happening somehow.  But that hasn't happened in.. uh.. Badari, for
> how many years has this been on the radar? :)

I used to have a test case that would reproduce the problem some what
consistently. But with invalidate_range() introduction and Jan Kara's
re-write of journal commit handling, I can't reproduce the problem
anymore. So I gave up fixing the problem which I can't reproduce.

If anyone has a testcase - I can take a look at the problem again.

Thanks,
Badari



