Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbYGWUQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbYGWUQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYGWUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:16:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45238
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755187AbYGWUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:16:07 -0400
Date: Wed, 23 Jul 2008 13:16:07 -0700 (PDT)
Message-Id: <20080723.131607.79681752.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: peterz@infradead.org, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080723114914.GF4561@ff.dom.local>
References: <1216810696.7257.175.camel@twins>
	<20080723113519.GE4561@ff.dom.local>
	<20080723114914.GF4561@ff.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 23 Jul 2008 11:49:14 +0000

> On Wed, Jul 23, 2008 at 11:35:19AM +0000, Jarek Poplawski wrote:
> > On Wed, Jul 23, 2008 at 12:58:16PM +0200, Peter Zijlstra wrote:
> ...
> > > When I look at the mac802.11 code in ieee80211_tx_pending() it looks
> > > like it can do with just one lock at a time, instead of all - but I
> > > might be missing some obvious details.
> > > 
> > > So I guess my question is, is netif_tx_lock() here to stay, or is the
> > > right fix to convert all those drivers to use __netif_tx_lock() which
> > > locks only a single queue?
> > > 
> > 
> > It's a new thing mainly for new hardware/drivers, and just after
> > conversion (older drivers effectively use __netif_tx_lock()), so it'll
> > probably stay for some time until something better is found. David,
> > will tell the rest, I hope.
> 
> ...And, of course, these new drivers should also lock a single queue
> where possible.

It isn't going away.

There will always be a need for a "stop all the TX queues" operation.
