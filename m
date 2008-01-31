Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYAaBIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYAaBIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYAaBH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:07:59 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:5928 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbYAaBH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:07:57 -0500
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] IB: add dmabarrier to ib_umem_get() prototype
X-Message-Flag: Warning: May contain useful information
References: <20080130055320.GU30022@sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 Jan 2008 17:07:43 -0800
In-Reply-To: <20080130055320.GU30022@sgi.com> (akepner@sgi.com's message of "Tue, 29 Jan 2008 21:53:20 -0800")
Message-ID: <adar6fyajkw.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Jan 2008 01:07:43.0322 (UTC) FILETIME=[AEC8FBA0:01C863A5]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
 > index 4e3128f..5b00408 100644
 > --- a/drivers/infiniband/core/umem.c
 > +++ b/drivers/infiniband/core/umem.c
 > @@ -74,7 +74,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 >   * @access: IB_ACCESS_xxx flags for memory being pinned
 >   */
 >  struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 > -			    size_t size, int access)
 > +			    size_t size, int access, int dmabarrier)
 >  {
 >  	struct ib_umem *umem;
 >  	struct page **page_list;

Two problems here, one major: this doesn't actually do anything with
the dmabarrier parameter, and one minor: it also doesn't add any
documentation for the parameter to the comment before the function.

 - R.
