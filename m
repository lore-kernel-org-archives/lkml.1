Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYGXJaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYGXJaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYGXJ3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:29:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYGXJ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:29:50 -0400
Date: Thu, 24 Jul 2008 02:29:50 -0700 (PDT)
Message-Id: <20080724.022950.20171380.davem@davemloft.net>
To: mingo@elte.hu
Cc: herbert@gondor.apana.org.au, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi
Subject: Re: [TCP bug, regression] stuck distcc connections in latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080724092517.GA31358@elte.hu>
References: <20080724060448.GA10203@elte.hu>
	<E1KLwlD-0001Ub-00@gondolin.me.apana.org.au>
	<20080724092517.GA31358@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 24 Jul 2008 11:25:18 +0200

> ok, i've booted the latest kernel on dione and the builds are running on 
> it now. It's using these settings currently:
> 
>  # cat /proc/sys/net/ipv4/tcp_syncookies
>  0
>  # cat /proc/sys/net/ipv4/tcp_sack
>  1
> 
> Just to make sure i have the right test-plan: assuming this 
> suspected-good kernel is trouble-free for say 48 hours, i should be able 
> to switch back to the suspected-broken variant, by doing:
> 
>    echo 1 > /proc/sys/net/ipv4/tcp_syncookies
> 
> without rebooting the kernel, right? And then if the bug comes back 
> again we've nailed it down to the area you suspect, correct?

You don't need the explicit tcp_sack=1, it's going to be '1' by
default.

Simply switching syncookies on and off will turn both SACK and
timestamps off when running the dist kernel.
