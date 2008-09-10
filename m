Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYIJXAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYIJXAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYIJXAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:00:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55221
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYIJXAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:00:32 -0400
Date: Wed, 10 Sep 2008 16:00:26 -0700 (PDT)
Message-Id: <20080910.160026.31554352.davem@davemloft.net>
To: ranjitm@google.com
Cc: tgraf@suug.ch, akpm@linux-foundation.org, kaber@trash.net,
       lizf@cn.fujitsu.com, menage@google.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Traffic control cgroups subsystem
From: David Miller <davem@davemloft.net>
In-Reply-To: <166fe7950809101556q61cb7e30m2d5e758304618f61@mail.gmail.com>
References: <Pine.LNX.4.64.0809101040280.7050@ranjit.corp.google.com>
	<20080910220115.GH20815@postel.suug.ch>
	<166fe7950809101556q61cb7e30m2d5e758304618f61@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ranjit Manomohan" <ranjitm@google.com>
Date: Wed, 10 Sep 2008 15:56:55 -0700

> That is correct for ingress, for egress the sk is already available in
> the skb so should be fine.

That is not something you can rely upon, even for egress, %100 of the time.

Some forms of reallocation and mangling might decide to orphan the SKB
and thus drop the skb->sk reference before you see the packet.  And they
are absolutely free to do this.

Just grep for skb_orphan().

Therefore, it is absolutely something you should not rely upon for
correct operation.

Like I said from the beginning, Thomas's approach is the superior one.
