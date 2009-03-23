Return-Path: <linux-kernel-owner+w=401wt.eu-S1751036AbZCWEVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036AbZCWEVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 00:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZCWEVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 00:21:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49314
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbZCWEVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 00:21:20 -0400
Date: Sun, 22 Mar 2009 21:21:07 -0700 (PDT)
Message-Id: <20090322.212107.55546529.davem@davemloft.net>
To: mpm@selenic.com
Cc: marcin.slusarz@gmail.com, netdev@vger.kernel.org, k-keiichi@bx.jp.nec.com,
       stable@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netconsole: fix BUG during net device "upping"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1237771258.4231.134.camel@calx>
References: <49C61AAA.8050507@gmail.com>
	<1237771258.4231.134.camel@calx>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Sun, 22 Mar 2009 20:20:58 -0500

> On Sun, 2009-03-22 at 12:02 +0100, Marcin Slusarz wrote:
> > When ndo_open (eg skge_up) function printks something, netconsole decides
> > it can use this device because it checks state only (netif_running) which is
> > set before ndo_open. Check device flags too.
> 
> That's fairly unfortunate semantics for netif_running. But if Dave
> agrees that it's reasonable for that to be set to true at this point in
> time, then I guess we'll go with it.

These kind of printk's simply are not allowed, we've removed such
printk's from other driver ->open() methods to fix this problem and
that's what should be done here.

I'm rejecting this patch.
