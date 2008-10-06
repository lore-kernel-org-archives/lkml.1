Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYJFVki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYJFVki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYJFVk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:40:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53183
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbYJFVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:40:27 -0400
Date: Mon, 06 Oct 2008 14:40:02 -0700 (PDT)
Message-Id: <20081006.144002.56418911.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: minyard@acm.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <48EA8197.6080502@cosmosbay.com>
References: <20081006185026.GA10383@minyard.local>
	<48EA8197.6080502@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Mon, 06 Oct 2008 23:22:31 +0200

> Me wondering what impact this synchronize_rcu() can have on mono-threaded
> VOIP applications using lot of UDP sockets. What is the maximum delay of
> this function ?

The cost is enormous, we really can't use it here.

I have a patch that did top-level socket destruction using RCU,
and that didn't use synchronize_rcu(), and that killed connection
rates by up to %20.

I can only imagine what the cost would be if I had to add such a call
in there.

Really, I can't consider these changes seriously, as-is.
