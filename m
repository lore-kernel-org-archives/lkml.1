Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbZEKBp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbZEKBp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZEKBpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:45:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35424 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZEKBpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:45:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com>
Message-Id: <20090511104310.B9C1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 11 May 2009 10:45:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 11 May 2009, KOSAKI Motohiro wrote:
> 
> > > The oom killer must be invoked regardless of the order if the allocation
> > > is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> > > free some memory.
> > 
> > This is intensional behavior. plus you change very widely caller bahavior.
> > if you don't have good test program, I nak this.
> > 
> 
> What exactly are you objecting to?  You don't want the oom killer called 
> for a __GFP_NOFAIL allocation above PAGE_ALLOC_COSTLY_ORDER that could not 
> reclaim any memory and would prefer that it loop endlessly in the page 
> allocator?  What's the purpose of that if the oom killer could free a very 
> large memory hogging task?

My point is, if we change gfp-flags meaning, we should change
unintentional affected caller.

Do you oppose this?



