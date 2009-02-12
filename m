Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZBLBgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZBLBgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZBLBg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:36:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756206AbZBLBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:36:29 -0500
Date: Wed, 11 Feb 2009 17:35:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Lin Ming <ming.m.lin@intel.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: specjbb2005 fails with 2.6.29-rc4
In-Reply-To: <1234401390.7699.29.camel@minggr.sh.intel.com>
Message-ID: <alpine.LFD.2.00.0902111733170.3189@localhost.localdomain>
References: <1234401390.7699.29.camel@minggr.sh.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Feb 2009, Lin Ming wrote:
> 
> Test with Jrockit VM fails. And it works well if OpenJDK is used
> instead.

I suspect maybe it uses hugetlbs?

There were a couple of commits to fix VM_ACCOUNT for hugepage areas 
recently. See

 - 5a6fe125950676015f5108fb71b2a67441755003: "Do not account for the 
   address space used by hugetlbfs using VM_ACCOUNT"

 - 17c9d12e126cb0de8d535dc1908c4819d712bc68: "Do not account for hugetlbfs 
   quota at mmap() time if mapping [SHM|MAP]_NORESERVE"

because hugetlb mappings have their own magical VM accounting.

So can you check if current -git fixes it?

		Linus
