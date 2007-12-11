Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbXLKMl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbXLKMl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 07:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbXLKMlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 07:41:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53622
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbXLKMlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 07:41:49 -0500
Date: Tue, 11 Dec 2007 04:41:49 -0800 (PST)
Message-Id: <20071211.044149.217878270.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [NET]: Fix Ooops of napi net_rx_action.
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1J24LV-0003ig-00@gondolin.me.apana.org.au>
References: <20071211.023218.31965443.davem@davemloft.net>
	<E1J24LV-0003ig-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 11 Dec 2007 20:36:21 +0800

> David Miller <davem@davemloft.net> wrote:
> >
> > How can the NAPI_STATE_SCHED bit be cleared externally yet we take
> > this list_move_tail() code path?
> 
> His driver is probably buggy.  When we had two drivers beginning
> with e100 we often forgot to apply fixes to the both of them.  Now
> that we have three it's even more confusing.
> 
> I just checked and indeed e1000e seems to be missing the NAPI fix
> that was applied to e1000.  Of course it doesn't rule out the
> possibility of another NAPI bug in e1000.

Thanks for checking.

Indeed I stuck the huge comment there in net_rx_action() above the
list move to try and explain things to people, so that if you saw a
crash in the list manipulation, you're go check the driver first.
