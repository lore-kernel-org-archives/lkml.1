Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYHHTdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYHHTdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYHHTcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:32:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:16401 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYHHTcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:32:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,329,1215414000"; 
   d="scan'208";a="324501187"
Date: Fri, 8 Aug 2008 12:32:53 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Wolfgang Walter <wolfgang.walter@stwm.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080808193252.GD607@linux-os.sc.intel.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <200808082109.47284.wolfgang.walter@stwm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808082109.47284.wolfgang.walter@stwm.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 12:09:46PM -0700, Wolfgang Walter wrote:
> I don't know though why kernel_fpu_begin exactly fixes the problem:

because it prevents taking a DNA fault inside the kernel (resulting
in TS_USEDFPU not set).

> 
> Maybe preemption must be disabled when padlocks RNG, ACE, Hash-engine etc. is
> used. Maybe just some barrier is needed which preempt_disable provides.

problem can happen even when preemption is disabled.

> What should I do now?

I will post your fix(including the other usages) with the appropriate changelog
shortly.

thanks,
suresh
