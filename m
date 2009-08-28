Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbZH1HVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbZH1HVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZH1HVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:21:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:46675 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbZH1HVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:21:42 -0400
Subject: Re: lmb: Remove __init from lmb_end_of_DRAM()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <200908271959.n7RJxNvV008624@hera.kernel.org>
References: <200908271959.n7RJxNvV008624@hera.kernel.org>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 17:21:28 +1000
Message-Id: <1251444088.20467.169.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 19:59 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/4f8ee2c9cc0e885d2bb50ef26db66150ab25213e
> Commit:     4f8ee2c9cc0e885d2bb50ef26db66150ab25213e
> Parent:     cf481442f2e086316ed8a1b3046f00ad23632ac4
> Author:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
> AuthorDate: Thu Aug 27 17:20:30 2009 +1000
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Thu Aug 27 12:25:26 2009 -0700
> 
>     lmb: Remove __init from lmb_end_of_DRAM()
>     
>     We call lmb_end_of_DRAM() to test whether a DMA mask is ok on a machine
>     without IOMMU, but this function is marked as __init.
>     
>     I don't think there's a clean way to get the top of RAM max_pfn doesn't
>     appear to include highmem or I missed (or we have a bug :-) so for now,
>     let's just avoid having a broken 2.6.31 by making this function
>     non-__init and we can revisit later.

And another brown paper bag for me ! Patch is fine, but doesn't do the
job because some idiot (me) didn't actually test (it looked so obvious)
and didn't notice somebody had the strange idea to also put __init on
the declaration in the .h file ! Ugh.

I'll send another patch later, have to run home now.

Cheers,
Ben.


