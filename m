Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYGWUOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYGWUOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYGWUOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:14:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45228
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbYGWUOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:14:42 -0400
Date: Wed, 23 Jul 2008 13:14:41 -0700 (PDT)
Message-Id: <20080723.131441.200166513.davem@davemloft.net>
To: peterz@infradead.org
Cc: jarkao2@gmail.com, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216810696.7257.175.camel@twins>
References: <1216806614.7257.152.camel@twins>
	<20080723101352.GD4561@ff.dom.local>
	<1216810696.7257.175.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 23 Jul 2008 12:58:16 +0200

> So I guess my question is, is netif_tx_lock() here to stay, or is the
> right fix to convert all those drivers to use __netif_tx_lock() which
> locks only a single queue?

It's staying.

It's trying to block all potential calls into the ->hard_start_xmit()
method of the driver, and the only reliable way to do that is to take
all the TX queue locks.  And in one form or another, we're going to
have this "grab/release all the TX queue locks" construct.

I find it interesting that this cannot be simply described to lockdep
:-)
