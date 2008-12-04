Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYLDGOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYLDGOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbYLDGOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:14:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46979
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756531AbYLDGOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:14:36 -0500
Date: Wed, 03 Dec 2008 22:14:36 -0800 (PST)
Message-Id: <20081203.221436.57914253.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4936EB04.8000609@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 03 Dec 2008 21:24:36 +0100

> [PATCH] percpu_counter: Fix __percpu_counter_sum()
> 
> This function should not write into percpu local storage,
> without proper locking, or some changes done on other cpus
> might be lost.
> 
> Adding proper locking would need to use atomic
> operations in fast path and would be expensive.
> 
> Results of __percpu_counter_sum() can be wrong, this is a
> known fact.
> 
> We also dont need to acquire the lock, this gives
> no better results.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Acked-by: David S. Miller <davem@davemloft.net>
