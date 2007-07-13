Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbXGMBOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbXGMBOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 21:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXGMBO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 21:14:29 -0400
Received: from mga06.intel.com ([134.134.136.21]:42401 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbXGMBO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 21:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,534,1175497200"; 
   d="scan'208";a="265609120"
Message-ID: <4696D1F3.2040507@ichips.intel.com>
Date: Thu, 12 Jul 2007 18:14:27 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
In-Reply-To: <adahco943ip.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  - Take a look at Sean's local SA caching patches.  I merged
>    everything else from Sean's tree, but I'm still undecided about
>    these.  I haven't read them carefully yet, but even aside from that
>    I don't have a good feeling about whether there's consensus about
>    this yet.  Any opinions about merging, for or against, would be
>    appreciated here.

Obviously I'm biased here, but we've definitely seen local caching of 
path records (PR) greatly improve performance for large MPI job runs. 
(Our largest jobs wouldn't run without it.)  The development of the 
feature was requested and paid for by the US national labs. 
Infinicon/Silverstorm/QLogic also had this feature in their IB stack for 
scalability reasons as well.  PR caching is done in the stack today by 
IPoIB.

The implementation is hidden under the current kernel ib_sa interface, 
is disabled by default, and automatically fails over to standard PR 
queries if needed.  Removing the cache later should be fairly easy.

But to be fair, it will be difficult to enable both QoS and local PR 
caching.  To me, this would be the strongest reason against using it. 
However, QoS places additional burden on the SA, which will make scaling 
even more challenging.

- Sean
