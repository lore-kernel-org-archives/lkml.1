Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbXF3KPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbXF3KPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXF3KO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:14:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40016 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbXF3KO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:14:58 -0400
Date: Sat, 30 Jun 2007 11:14:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, cmm@us.ibm.com
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070630101442.GA23568@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Chinner <dgc@sgi.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Suparna Bhattacharya <suparna@in.ibm.com>, torvalds@osdl.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, cmm@us.ibm.com
References: <20070426180332.GA7209@amitarora.in.ibm.com> <20070509160102.GA30745@amitarora.in.ibm.com> <20070510005926.GT85884050@sgi.com> <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614091458.GH5181@schatzie.adilger.int>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 03:14:58AM -0600, Andreas Dilger wrote:
> I suppose it might be a bit late in the game to add a "goal"
> parameter and e.g. FA_FL_REQUIRE_GOAL, FA_FL_NEAR_GOAL, etc to make
> the API more suitable for XFS?  The goal could be a single __u64, or
> a struct with e.g. __u64 byte offset (possibly also __u32 lun like
> in FIEMAP).  I guess the one potential limitation here is the
> number of function parameters on some architectures.

This isn't really about "more suitable for XFS" but more about more
suitable for sophisticated layout decisions.

But I'm still not confident this should be shohorned into this
syscall.  In fact I'm already rather unhappy about the feature churn in
the current patch series.

The more I think about it the more I'd prefer we would just put a simple
syscall in that implements nothing but the posix_fallocate(3) semantics
as defined in SuS, and then go on to brainstorm about advanced
preallocation / layout hint semantics.

