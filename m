Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbXGXIvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbXGXIvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbXGXIvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:51:03 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:43113 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465AbXGXIu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:50:59 -0400
Date: Tue, 24 Jul 2007 02:50:56 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
       Mingming Cao <cmm@us.ibm.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Chris Ahna <christopher.j.ahna@intel.com>,
       David Mosberger-Tang <davidm@hpl.hp.com>,
       Kyle McMartin <kyle@parisc-linux.org>,
       Dave Jones <davej@codemonkey.org.uk>, Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Message-ID: <20070724085056.GE5992@schatzie.adilger.int>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Fengguang Wu <fengguang.wu@gmail.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
	Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Chris Ahna <christopher.j.ahna@intel.com>,
	David Mosberger-Tang <davidm@hpl.hp.com>,
	Kyle McMartin <kyle@parisc-linux.org>,
	Dave Jones <davej@codemonkey.org.uk>, Dave Airlie <airlied@linux.ie>
References: <20070721210005.000228000@chello.nl> <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com> <20070722081010.GA6317@mail.ustc.edu.cn> <1185093236.6344.87.camel@localhost.localdomain> <46A46E4B.7050007@yahoo.com.au> <385201377.00678@ustc.edu.cn> <20070723124009.5fcf4fef.akpm@linux-foundation.org> <385238729.01475@ustc.edu.cn> <20070723181701.c5551449.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723181701.c5551449.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 23, 2007  18:17 -0700, Andrew Morton wrote:
> hm, yes, there is a risk that the code was accidentally correct.  Or the
> code has only ever dealt with power-of-2 inputs, in which case it happens
> to work either way.
> 
> David(s) and ext4-people: could we please have a close review of these
> changes?
> > @@ -1706,8 +1704,8 @@ static int ext4_fill_super (struct super
> > -	sbi->s_addr_per_block_bits = log2(EXT4_ADDR_PER_BLOCK(sb));
> > -	sbi->s_desc_per_block_bits = log2(EXT4_DESC_PER_BLOCK(sb));
> > +	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
> > +	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));

For the ext[234] code there has only ever been power-of-two values for
ADDR_PER_BLOCK() and DESC_PER_BLOCK().

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

