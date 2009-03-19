Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZCSBUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZCSBUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZCSBUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:20:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:32081 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZCSBUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:20:19 -0400
Subject: Re: High contention on the sk_buff_head.lock
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: David Miller <davem@davemloft.net>
Cc: ghaskins@novell.com, vernux@us.ibm.com, andi@firstfloor.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, pmullaney@novell.com
In-Reply-To: <20090318.180355.228447835.davem@davemloft.net>
References: <49C16349.9030503@us.ibm.com>
	 <20090318.143844.173112261.davem@davemloft.net>
	 <49C16D7C.3080003@novell.com>
	 <20090318.180355.228447835.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 18:13:11 -0700
Message-Id: <1237425191.8204.41.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 18:03 -0700, David Miller wrote:
> From: Gregory Haskins <ghaskins@novell.com>
> Date: Wed, 18 Mar 2009 17:54:04 -0400
> 
> > Note that -rt doesnt typically context-switch under contention anymore
> > since we introduced adaptive-locks.  Also note that the contention
> > against the lock is still contention, regardless of whether you have -rt
> > or not.  Its just that the slow-path to handle the contended case for
> > -rt is more expensive than mainline.  However, once you have the
> > contention as stated, you have already lost.
> 
> First, contention is not implicitly a bad thing.
> 

Its a bad thing when it does not scale.

> Second, if the -rt kernel is doing adaptive spinning I see no
> reason why that adaptive spinning is not kicking in here to
> make this problem just go away.
> 

If only the first of N contending threads gets to spin, 2..N would
context-switch.


> This lock is held for mere cycles, just to unlink an SKB from
> the networking qdisc, and then it is immediately released.

For very short hold times, and heavy contention, as well as for
scalability, the solution may lie in tunable spinner-count and adaptive
spinner time-out.

Sven

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

