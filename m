Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbYCFJld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbYCFJld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760827AbYCFJlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:41:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:13203 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760744AbYCFJkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ocMwkZehsegWjuJiKTOcXA9ZEXsQirc8Xz1aPUCv0lZT2rnqPOQkUMDVK7cN0y4r+qtJIw6NDlOP2aNsCQjBsdwVSJmFzQ85GOBkWv88UL21GTt+At5cHiQIypwklFkX45NaG3QahRwVZZ09VIazQ8B8IiYNGq5g7sB00vtYZAo=
Date: Thu, 6 Mar 2008 09:41:57 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: netdev@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Probably lockdep bug Re: circular locking, mirred,
	2.6.24.2
Message-ID: <20080306094156.GA3954@ff.dom.local>
References: <20080305103935.M76165@visp.net.lb> <20080305135448.GA4636@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305135448.GA4636@ff.dom.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 01:54:48PM +0000, Jarek Poplawski wrote:
> Hi,
> 
> dev->queue_lock is taken in a scenario like below: always after
> dev->ingress_lock and p->tcfc_lock, so just like on this last
> backtrace with info about held locks. But this report shows that
> lockdep for some reason forgot the history before dev->queue_lock,
> and recorded it again. It seems, even if there is something wrong
> with init lockdep shouldn't report it like this.

...Hmmm... On the other hand, despite misleading dependency chain on
this report, lockdep seems to be right: dev->queue_lock and
dev->ingress_lock are really taken in a different order from
qdisc_lock_tree() and while using act_mirred! Now I wonder why this
warning is so rare?

So, let's give a break to lockdep maintainers and linux-kernel, and
try to figure it out more in netdev...

Jarek P.
