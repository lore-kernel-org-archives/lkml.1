Return-Path: <linux-kernel-owner+w=401wt.eu-S1761846AbYHFUOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761846AbYHFUOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbYHFUOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:14:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:21127 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758306AbYHFUOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,316,1215414000"; 
   d="scan'208";a="426702490"
Date: Wed, 6 Aug 2008 13:14:02 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Wolfgang Walter <wolfgang.walter@stwm.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080806201401.GA607@linux-os.sc.intel.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <200807301411.01622.wolfgang.walter@stwm.de> <20080806103354.GA31623@gondor.apana.org.au> <200808061933.25631.wolfgang.walter@stwm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808061933.25631.wolfgang.walter@stwm.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:33:25AM -0700, Wolfgang Walter wrote:
> Hello Herbert,
> 
> I think I finally found the problem.
> 
> Here a short description again: all our routers with a via C3 using padlock for AES-encryption are
> crashing with 2.6.26 while they work fine with 2.6.25. Not using padlock
> (i.e. using the i386 assembler version of AES) they just work fine.

Both the padlock version or asm version don't use FP/math registers, right?
It is interesting that you don't see the problem with asm version
but see the problem with padlock version.

Does disabling CONFIG_PREEMPT in 2.6.26 change anything? And also,
can you provide the complete kernel log till the point of failure(oops
that you sent doesn't have the call trace info)

thanks,
suresh
