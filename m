Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZKXPSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZKXPSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbZKXPSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:18:41 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34200 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbZKXPSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:18:40 -0500
Date: Tue, 24 Nov 2009 09:17:40 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
In-Reply-To: <1259049753.29789.49.camel@localhost>
Message-ID: <alpine.DEB.2.00.0911240914190.14045@router.home>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>  <1258440521.11321.32.camel@localhost> <1258443101.11321.33.camel@localhost>  <1258450465.11321.36.camel@localhost>  <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>  <1258966270.29789.45.camel@localhost>
  <alpine.DEB.2.00.0911230830300.26432@router.home> <1259049753.29789.49.camel@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Zhang, Yanmin wrote:

> > True.... We need to find some alternative to per cpu data to scale mmap
> > sem then.
> I ran lots of benchmarks such like specjbb2005/hackbench/tbench/dbench/iozone
> /sysbench_oltp(mysql)/aim7 against percpu tree(based on 2.6.32-rc7) on a 4*8*2 logical
> cpu machine, and didn't find big result difference between with your patch and without
> your patch.

This affects loads that heavily use mmap_sem. You wont find too many
issues in tests that do not run processes with a large thread count and
cause lots of faults or uses of get_user_pages(). The tests you list are
not of that nature.

