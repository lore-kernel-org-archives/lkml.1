Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbXBDUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbXBDUXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXBDUXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:23:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41759
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbXBDUXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:23:49 -0500
Date: Sun, 04 Feb 2007 12:23:48 -0800 (PST)
Message-Id: <20070204.122348.38681159.davem@davemloft.net>
To: t.hisch@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: remove a call to skb_queue_len() in inet_diag.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070204142921.GA5787@unknown-00-0d-60-79-ca-00.lan>
References: <Pine.LNX.4.64.0612311547200.30821@localhost.localdomain>
	<20070204142921.GA5787@unknown-00-0d-60-79-ca-00.lan>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Hisch <t.hisch@gmail.com>
Date: Sun, 4 Feb 2007 15:29:21 +0100

> remove unneeded call to skb_queue_len (skb_dequeue already checks queuelen) and
> replace a sizeof() by a Netlink Macro
> 
> Signed-off-by: Thomas Hisch <t.hisch@gmail.com>

You don't understand the code you are editing :-)

We want to process the number of packets present when we
start the function, other threads can add more packets to
the queue meanwhile and we don't want to keep dequeueing
in that case or else we can theoretically run forever with
a fast enough producer.

Also, please post all networking patches to netdev@vger.kernel.org,
the majority of the networking developers do not read linux-kernel.

Thank you.
