Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbXJOWV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbXJOWV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbXJOWVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:21:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36616
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755025AbXJOWVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:21:21 -0400
Date: Mon, 15 Oct 2007 15:21:26 -0700 (PDT)
Message-Id: <20071015.152126.85410587.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shemminger@linux-foundation.org, jgarzik@pobox.com
Subject: Re: WARNING: at net/core/dev.c:2161 net_rx_action()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071015220720.GA16101@elte.hu>
References: <20071015.125731.79447899.davem@davemloft.net>
	<20071015220357.GA7174@elte.hu>
	<20071015220720.GA16101@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Oct 2007 00:07:20 +0200

> looking at the dev.c code - can napi_struct->weight be zero 
> legitimately? If yes then the 0 gets passed to the driver and the driver 
> would return 1 - violating the assertion.

I touched upon this in another reply.

For forcedeth it should never be zero, it gets set in
netif_napi_add() to RX_WORK_PER_LOOP which is unconditionally
defined to 64.

Afterwards napi->weight should never be modified and that is
what is passed into n->poll().

Perhaps some memory scribble is causing it to be zero'd.
