Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbXLEGGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbXLEGGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 01:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbXLEGGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 01:06:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49254
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbXLEGGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 01:06:35 -0500
Date: Tue, 04 Dec 2007 22:06:34 -0800 (PST)
Message-Id: <20071204.220634.112782343.davem@davemloft.net>
To: simon@fire.lp0.eu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4755A21F.2020407@simon.arlott.org.uk>
References: <4755A21F.2020407@simon.arlott.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Arlott <simon@fire.lp0.eu>
Date: Tue, 04 Dec 2007 18:53:19 +0000

> If I have a IPsec rule like:
> 	spdadd 192.168.7.8 1.2.3.4 any -P out ipsec esp/transport//require;
> (i.e. a remote host 1.2.3.4 which will not respond)
> 
> Then any attempt to communicate with 1.2.3.4 will block, even when using non-blocking sockets:

If you don't like this behavior:

	echo "1" >/proc/sys/net/core/xfrm_larval_drop

but those initial connection setup packets will be dropped while
waiting for the IPSEC route to be resolved, and in your 8 hour case
the TCP connect will fail.

Anyways, the choice for different behavior is there, select it
to suit your tastes.
