Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYHIOhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYHIOhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbYHIOhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:37:38 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:54381 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754447AbYHIOhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:37:37 -0400
Date: Sat, 9 Aug 2008 22:37:27 +0800
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
Message-ID: <20080809143727.GA30499@gondor.apana.org.au>
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
> With out the recent dynamic fpu allocation changes, while we don't see oops,
> there is a possible race still present in older kernels(for example,
> while kernel is using kernel_fpu_begin() in some optimized clear/copy
> page and an interrupt/softirq happens which uses these padlock
> instructions generating DNA fault).

No this wasn't a problem because kernel_fpu_begin clears TS and
therefore we don't get faults on SSE instructions.

However, with your patch it will become a problem due to the
fact that it wasn't designed to be nested.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
