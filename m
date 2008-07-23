Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYGWLoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYGWLoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYGWLoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:44:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:31052 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYGWLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wLcIlarsGOm1rLzUhgQHS1jqMymozpimNn5tdFd/iHtKt0SgHiPDsLCfaAyQe926pg
         QycahILmPvrhbdIVpuoq8FGX8XpdJ7yoq4JagRVdRlMsQ9QSPmuO/yvXv12QmTSQXdh6
         onOPXNlmB5uobBcWS+apOFFXFC9zv1w1WZ4/8=
Date: Wed, 23 Jul 2008 11:49:14 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, Larry.Finger@lwfinger.net,
       kaber@trash.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723114914.GF4561@ff.dom.local>
References: <20080722.160409.216536011.davem@davemloft.net> <20080723062036.GA4561@ff.dom.local> <20080723.005921.113868915.davem@davemloft.net> <20080723085452.GB4561@ff.dom.local> <1216803786.7257.146.camel@twins> <20080723093459.GC4561@ff.dom.local> <1216806614.7257.152.camel@twins> <20080723101352.GD4561@ff.dom.local> <1216810696.7257.175.camel@twins> <20080723113519.GE4561@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723113519.GE4561@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 11:35:19AM +0000, Jarek Poplawski wrote:
> On Wed, Jul 23, 2008 at 12:58:16PM +0200, Peter Zijlstra wrote:
...
> > When I look at the mac802.11 code in ieee80211_tx_pending() it looks
> > like it can do with just one lock at a time, instead of all - but I
> > might be missing some obvious details.
> > 
> > So I guess my question is, is netif_tx_lock() here to stay, or is the
> > right fix to convert all those drivers to use __netif_tx_lock() which
> > locks only a single queue?
> > 
> 
> It's a new thing mainly for new hardware/drivers, and just after
> conversion (older drivers effectively use __netif_tx_lock()), so it'll
> probably stay for some time until something better is found. David,
> will tell the rest, I hope.

...And, of course, these new drivers should also lock a single queue
where possible.
 
Jarek P.
