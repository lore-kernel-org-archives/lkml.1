Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYHISOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYHISOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYHISOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:14:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:27559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYHISOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,334,1215414000"; 
   d="scan'208";a="427737089"
Date: Sat, 9 Aug 2008 11:14:06 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080809181406.GG13158@linux-os.sc.intel.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080806201401.GA607@linux-os.sc.intel.com> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com> <489C97FB.2030408@zytor.com> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809143727.GA30499@gondor.apana.org.au> <489DC05E.2080901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489DC05E.2080901@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 09:05:50AM -0700, H. Peter Anvin wrote:
> Herbert Xu wrote:
> > On Fri, Aug 08, 2008 at 04:11:21PM -0700, Suresh Siddha wrote:
> >> With out the recent dynamic fpu allocation changes, while we don't see oops,
> >> there is a possible race still present in older kernels(for example,
> >> while kernel is using kernel_fpu_begin() in some optimized clear/copy
> >> page and an interrupt/softirq happens which uses these padlock
> >> instructions generating DNA fault).
> >
> > No this wasn't a problem because kernel_fpu_begin clears TS and
> > therefore we don't get faults on SSE instructions.
> >
> > However, with your patch it will become a problem due to the
> > fact that it wasn't designed to be nested.
> >
> 
> We're invoking this code from interrupt handlers?

Yes. Padlock/ipsec usage seems to be happening in the interrupt
context and this triggered the bug that started this thread.

thanks,
suresh
