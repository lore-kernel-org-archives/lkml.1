Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbZFPTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbZFPTIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760418AbZFPTI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:08:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48095
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759965AbZFPTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:08:26 -0400
Date: Tue, 16 Jun 2009 12:08:29 -0700 (PDT)
Message-Id: <20090616.120829.182011393.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: eric.dumazet@gmail.com, mingo@elte.hu, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.01.0906161155400.3282@localhost.localdomain>
References: <4A37A058.1030701@gmail.com>
	<4A37AA0C.40507@gmail.com>
	<alpine.LFD.2.01.0906161155400.3282@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Jun 2009 11:59:34 -0700 (PDT)

> At the very least, add a helper function for "do I actually have 
> outstanding allocations" or something like that. IOW, do a 
> 
> 	/*
> 	 * Comment here about that magical "1"
> 	 */
> 	static inline int sk_has_allocations(struct sock *sk)
> 	{
> 		return atomic_read(&sk->sk_wmem_alloc) > 1 ||
> 			atomic_read(&sk->sk_rmem_alloc);
> 	}
> 
> and then make the various network protocols use that, rather than 
> open-coding some random internal implementation magic.

I agree, this should be handled with a helper function
abstraction rather than putting "1" checks all over the place.
