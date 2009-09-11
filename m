Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZIKTw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZIKTw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZIKTw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:52:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50799
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755908AbZIKTwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:52:25 -0400
Date: Fri, 11 Sep 2009 12:52:42 -0700 (PDT)
Message-Id: <20090911.125242.244008840.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: albcamus@gmail.com, parag.lkml@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net: Fix sock_wfree() race
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090911.114337.150207703.davem@davemloft.net>
References: <4AA64A11.7090804@gmail.com>
	<4AA6DF7B.7060105@gmail.com>
	<20090911.114337.150207703.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 11 Sep 2009 11:43:37 -0700 (PDT)

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 09 Sep 2009 00:49:31 +0200
> 
>> [PATCH] net: Fix sock_wfree() race
>> 
>> Commit 2b85a34e911bf483c27cfdd124aeb1605145dc80
>> (net: No more expensive sock_hold()/sock_put() on each tx)
>> opens a window in sock_wfree() where another cpu
>> might free the socket we are working on.
>> 
>> Fix is to call sk->sk_write_space(sk) only
>> while still holding a reference on sk.
>> 
>> Since doing this call is done before the 
>> atomic_sub(truesize, &sk->sk_wmem_alloc), we should pass truesize as 
>> a bias for possible sk_wmem_alloc evaluations.
>> 
>> Reported-by: Jike Song <albcamus@gmail.com>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Applied to net-next-2.6, thanks.  I'll queue up your simpler
> version for -stable.

Eric, I have to revert, as you didn't update the callbacks
of several protocols such as SCTP and RDS in this change.

Let me know when you have a fixed version of this patch :-)
