Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYGWUzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYGWUzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYGWUzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:55:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59338
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbYGWUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:55:30 -0400
Date: Wed, 23 Jul 2008 13:55:30 -0700 (PDT)
Message-Id: <20080723.135530.63039342.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: peterz@infradead.org, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080723204335.GA14788@ami.dom.local>
References: <20080723114914.GF4561@ff.dom.local>
	<20080723.131607.79681752.davem@davemloft.net>
	<20080723204335.GA14788@ami.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 23 Jul 2008 22:43:35 +0200

> On Wed, Jul 23, 2008 at 01:16:07PM -0700, David Miller wrote:
> ...
> > There will always be a need for a "stop all the TX queues" operation.
> 
> The question is if the current way is "all correct". As a matter of
> fact I think Peter's doubts could be justified: taking "USHORT_MAX"
> locks looks really dubious (so maybe it's not so strange lockdep
> didn't get used to this).

There are, of course, potentially other ways to achieve the objective.

And for non-multiqueue aware devices (which is the vast majority of
the 400 or so networking drivers we have) there is only one queue and
thus one lock taken.
