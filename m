Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYGTHF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYGTHF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 03:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYGTHFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 03:05:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35407
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752079AbYGTHFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 03:05:10 -0400
Date: Sun, 20 Jul 2008 00:05:09 -0700 (PDT)
Message-Id: <20080720.000509.20260185.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: greearb@candelatech.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] netdev: debugging option
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080719230424.190957a3@extreme>
References: <20080719011709.GA5947@disturbed>
	<48821DEF.1040306@candelatech.com>
	<20080719230424.190957a3@extreme>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Sat, 19 Jul 2008 23:04:24 -0700

> This adds a debugging option for network devices. It could grow to add other
> uses, but for now just add some messages about device reference counting.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

I think this is useful but it could use some minor
mods before we put it in.

For example, this thing will spam the logs in at least two
common cases:

1) Lots of routing cache replacements

2) For older drivers using netif_rx() (and therefore, every
   current tunnel), every RX packet will trigger a log message

So we really need to add some kind of run time enable and also a
filter of some sort, even if it's just on device.
