Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYC1Obv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYC1Obv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYC1Obl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:31:41 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:38102 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbYC1Obk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:31:40 -0400
Subject: Re: [patch 09/10] Hugetlb common code update for System z.
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, haveblue@us.ibm.com,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20080328140634.GA29218@elte.hu>
References: <20080312173155.703966894@de.ibm.com>
	 <20080312173218.186436562@de.ibm.com>
	 <1205344286.9828.91.camel@nimitz.home.sr71.net>
	 <1205363937.5237.60.camel@localhost.localdomain>
	 <20080312164303.cac9cab5.akpm@linux-foundation.org>
	 <1206713119.5186.52.camel@localhost.localdomain>
	 <20080328140634.GA29218@elte.hu>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 15:33:28 +0100
Message-Id: <1206714808.5186.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 15:06 +0100, Ingo Molnar wrote:
> * Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:
> 
> >  include/asm-sh/hugetlb.h      |   28 +++++++++++++++++++++++++
> >  include/asm-sparc64/hugetlb.h |   30 +++++++++++++++++++++++++++
> >  include/asm-x86/hugetlb.h     |   28 +++++++++++++++++++++++++
> 
> these seem largely duplicated - shouldnt there be an 
> asm-generic/hugetlb.h instead, which asm/hugetlb.h could include to get 
> default behavior? It would probably reduce the linecount of your patch 
> as well.

Right, asm-generic was also suggested by Andrew as a first step, before
getting rid of the ARCH_HAS_xxx stuff, and it would also reduce the loc.
But it would make things complicated if one architecture later wants to
take out some of the generic stuff to define it on their own, then they'd
need to touch all architecture headers again.

So I thought I'd rather not introduce the asm-generic header at all but
let all architectures have their own headers, risking code duplication
but hopefully making future updates easier.

--
Gerald Schaefer

