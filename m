Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXKWBFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXKWBFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXKWBE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:04:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47296
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbXKWBE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:04:58 -0500
Date: Thu, 22 Nov 2007 17:04:58 -0800 (PST)
Message-Id: <20071122.170458.260273849.davem@davemloft.net>
To: wferi@niif.hu
Cc: shemminger@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: network driver usage count
From: David Miller <davem@davemloft.net>
In-Reply-To: <87myt7nt0k.fsf@szonett.ki.iif.hu>
References: <87hcjf9yd4.fsf@tac.ki.iif.hu>
	<20071121130445.569d2176@freepuppy.rosehill>
	<87myt7nt0k.fsf@szonett.ki.iif.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wagner Ferenc <wferi@niif.hu>
Date: Wed, 21 Nov 2007 23:16:59 +0100

> Hmm, that would warrant nuking all the reference counts on every
> driver.

That's not true.  When packets are in flight, references go
to the device and the device cannot be unloaded until those
references get dropped.

This behavior makes sense because otherwise you have to figure
out the myriad of references (each ipv4 address, each ipv6
address, routes, ARP entries, etc.) just to perform such a
simple operation.

If you do not mean to unload the device, simply do not do it.
