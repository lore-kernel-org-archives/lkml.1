Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZEKHkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZEKHkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZEKHkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:40:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:3358 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZEKHkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=QoRMrHhTEfljtfJQjaU0NlrPeKysrZhHdLqoSojKeHLuZYEqhYDbtIeht1Y83jLbsh
         PjPFZLQ3qTRNSItq+H75YnAfuDodzBNa9S+o/aYGXa3mc3v3q07+RSiBQg9aGX1F702g
         KDTDpDHn/bcgIN65sgGJ75+pW1ZOSFZj1WW9I=
Date: Mon, 11 May 2009 16:40:08 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Message-Id: <20090511164008.894320db.minchan.kim@barrios-desktop>
In-Reply-To: <20090511104310.B9C1.A69D9226@jp.fujitsu.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com>
	<20090511104310.B9C1.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 10:45:05 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Mon, 11 May 2009, KOSAKI Motohiro wrote:
> > 
> > > > The oom killer must be invoked regardless of the order if the allocation
> > > > is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> > > > free some memory.
> > > 
> > > This is intensional behavior. plus you change very widely caller bahavior.
> > > if you don't have good test program, I nak this.
> > > 
> > 
> > What exactly are you objecting to?  You don't want the oom killer called 
> > for a __GFP_NOFAIL allocation above PAGE_ALLOC_COSTLY_ORDER that could not 
> > reclaim any memory and would prefer that it loop endlessly in the page 
> > allocator?  What's the purpose of that if the oom killer could free a very 
> > large memory hogging task?
> 
> My point is, if we change gfp-flags meaning, we should change
> unintentional affected caller.
> 
> Do you oppose this?
>

I agree KOSAKI's opinion. 
We already have a different flags. 

 * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
 * _might_ fail.  This depends upon the particular VM implementation.
 *
 * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures.

When we use __GFP_NOFAIL, we always have to use it carefully.
If you change the meaning of __GFP_NOFAIL, the intension of them who have been used it carefully  may be lost. It's my concern.


-- 
Kinds Regards
Minchan Kim
