Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZCSBEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZCSBEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZCSBEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:04:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39631
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbZCSBEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:04:08 -0400
Date: Wed, 18 Mar 2009 18:03:55 -0700 (PDT)
Message-Id: <20090318.180355.228447835.davem@davemloft.net>
To: ghaskins@novell.com
Cc: vernux@us.ibm.com, andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       pmullaney@novell.com
Subject: Re: High contention on the sk_buff_head.lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <49C16D7C.3080003@novell.com>
References: <49C16349.9030503@us.ibm.com>
	<20090318.143844.173112261.davem@davemloft.net>
	<49C16D7C.3080003@novell.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>
Date: Wed, 18 Mar 2009 17:54:04 -0400

> Note that -rt doesnt typically context-switch under contention anymore
> since we introduced adaptive-locks.  Also note that the contention
> against the lock is still contention, regardless of whether you have -rt
> or not.  Its just that the slow-path to handle the contended case for
> -rt is more expensive than mainline.  However, once you have the
> contention as stated, you have already lost.

First, contention is not implicitly a bad thing.

Second, if the -rt kernel is doing adaptive spinning I see no
reason why that adaptive spinning is not kicking in here to
make this problem just go away.

This lock is held for mere cycles, just to unlink an SKB from
the networking qdisc, and then it is immediately released.
