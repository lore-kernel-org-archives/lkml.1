Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbZCWIPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbZCWIPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbZCWIPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:15:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51904
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756606AbZCWIPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:15:21 -0400
Date: Mon, 23 Mar 2009 01:15:08 -0700 (PDT)
Message-Id: <20090323.011508.140910146.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: mpm@selenic.com, marcin.slusarz@gmail.com, netdev@vger.kernel.org,
       k-keiichi@bx.jp.nec.com, stable@kernel.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netconsole: fix BUG during net device "upping"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090323081158.GB4976@ff.dom.local>
References: <20090323080455.GA4976@ff.dom.local>
	<20090323.010541.94308473.davem@davemloft.net>
	<20090323081158.GB4976@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 23 Mar 2009 08:11:58 +0000

> On Mon, Mar 23, 2009 at 01:05:41AM -0700, David Miller wrote:
> > From: Jarek Poplawski <jarkao2@gmail.com>
> > Date: Mon, 23 Mar 2009 08:04:55 +0000
> > 
> > > What is the rationale of this decision? printk is a basic tool,
> > > especially designed to work in as many places as possible, and
> > > netconsole is rather something secondary (sorry Matt)?!
> > 
> > And this basic tool cannot work from the drivers ->open() method.
> 
> And in any function used in the drivers ->open(). BTW, with Marcin's
> patch it can...

This issue came up before, and after we added the netif_running()
check we hit this IIF_UP one and at the time we looked into it
and the result we came up with is that you just can't do it in
a network driver's ->open()

Look up the thread, I'm too lazy...

