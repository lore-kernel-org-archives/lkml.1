Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYDBIYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYDBIYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYDBIYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:24:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47336
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbYDBIYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:24:06 -0400
Date: Wed, 02 Apr 2008 01:24:06 -0700 (PDT)
Message-Id: <20080402.012406.246863209.davem@davemloft.net>
To: kosaki.motohiro@jp.fujitsu.com
Cc: akpm@linux-foundation.org, csnook@redhat.com, davej@codemonkey.org.uk,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: GFP_ATOMIC page allocation failures.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080402171104.9591.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <47F32789.2070703@redhat.com>
	<20080402005646.f8df1c1b.akpm@linux-foundation.org>
	<20080402171104.9591.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 02 Apr 2008 17:17:50 +0900

> if network guys hope known-good driver should call 
> __netdev_alloc_skb(dev, length, GFP_ATOMIC|__GFP_NOWARN) instead netdev_alloc_skb,
> I think we should make netdev_alloc_skb_nowarn.

Giving it a proper name like this takes away the indication that this
situation is very special.

Two leading underscores to an interface means "something special and
unusual requiring more careful consideration than usual is occuring
here."  netdev_alloc_skb_nowarn() on the other hand, does not
convey this meaning.

And we will have very few drivers that use this construct, thus it
really is best to handle things the way Andrew has.
