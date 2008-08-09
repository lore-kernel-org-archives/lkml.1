Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYHINcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYHINcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 09:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYHINcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 09:32:02 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:49090 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751547AbYHINcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 09:32:00 -0400
Date: Sat, 9 Aug 2008 21:31:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080809133138.GA30064@gondor.apana.org.au>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080806201401.GA607@linux-os.sc.intel.com> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com> <489C97FB.2030408@zytor.com> <20080808231121.GA13158@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808231121.GA13158@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 04:11:21PM -0700, Suresh Siddha wrote:
>
> b) Looking deeper, do we need to disable interrupts in the kernel_fpu_begin()?
>    Is there a recursive case, where interrupt context also touches FPU/SSE
>    registers?

Even if there wasn't one before, there is going to be one now
because as you pointed out yourself, if we get an inbound IPsec
packet between any kernel_fpu_begin/kernel_fpu_end area, we could
get a nested kernel_fpu_end which puts us back to square one wrt
to the original race.

So clearly we need to think more about this issue.

Unless we can come up with a new solution quickly, I recommend
that we back out the FPU changes.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
