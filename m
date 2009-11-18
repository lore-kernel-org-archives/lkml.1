Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZKRFzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZKRFzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZKRFzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:55:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36472 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZKRFzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:55:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1258491379.3918.48.camel@laptop>
References: <20091117172802.3DF4.A69D9226@jp.fujitsu.com> <1258491379.3918.48.camel@laptop>
Message-Id: <20091118144418.3E17.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 18 Nov 2009 14:55:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-11-17 at 17:33 +0900, KOSAKI Motohiro wrote:
> > 
> > if there is so such reason. we might need to implement another MM trick.
> > but keeping this strage usage is not a option. All memory freeing activity
> > (e.g. page out, task killing) need some memory. we need to protect its
> > emergency memory. otherwise linux reliability decrease dramatically when
> > the system face to memory stress. 
> 
> In general PF_MEMALLOC is a particularly bad idea, even for the VM when
> not coupled with limiting the consumption. That is one should make an
> upper-bound estimation of the memory needed for a writeout-path per
> page, and reserve a small multiple thereof, and limit the number of
> pages written out so as to never exceed this estimate.
> 
> If the current mempool interface isn't sufficient (not hard to imagine),
> look at the swap over NFS patch-set, that includes a much more able
> reservation scheme, and accounting framework.

Yes, I agree.

In this discussion, some people explained why their subsystem need
emergency memory, but nobody claim sharing memory pool against VM and
surely want to stop reclaim (PF_MEMALLOC's big side effect).

OK. I try to review your patch carefully and remake this patch series on top
your reservation framework in swap-over-nfs patch series.



