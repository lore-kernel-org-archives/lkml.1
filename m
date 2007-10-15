Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbXJOWj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbXJOWj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXJOWjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:39:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53556
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbXJOWjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:39:48 -0400
Date: Mon, 15 Oct 2007 15:39:53 -0700 (PDT)
Message-Id: <20071015.153953.106262983.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shemminger@linux-foundation.org, jgarzik@pobox.com
Subject: Re: [patch] forcedeth: fix the NAPI poll function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071015223009.GA27425@elte.hu>
References: <20071015220357.GA7174@elte.hu>
	<20071015220720.GA16101@elte.hu>
	<20071015223009.GA27425@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Oct 2007 00:30:09 +0200

> Subject: forcedeth: fix the NAPI poll function
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix the forcedeth NAPI poll function to not emit this warning:
> 
> [  186.635916] WARNING: at net/core/dev.c:2166 net_rx_action()
> [  186.641351]  [<c060d9f5>] net_rx_action+0x145/0x1b0
> [  186.646191]  [<c011d752>] __do_softirq+0x42/0x90
> [  186.650784]  [<c011d7c6>] do_softirq+0x26/0x30
> [  186.655202]  [<c011db48>] local_bh_enable+0x48/0xa0
> [  186.660055]  [<c06023e0>] lock_sock_nested+0xa0/0xc0
> [  186.664995]  [<c065da16>] tcp_recvmsg+0x16/0xbc0
> [  186.669588]  [<c013e94b>] __generic_file_aio_write_nolock+0x27b/0x520
> [  186.676001]  [<c0601d75>] sock_common_recvmsg+0x45/0x70
> [  186.681202]  [<c05ff5df>] sock_aio_read+0x11f/0x140
> [  186.686054]  [<c015c086>] do_sync_read+0xc6/0x110
> [  186.690735]  [<c012b9b0>] autoremove_wake_function+0x0/0x40
> [  186.696280]  [<c060dcfc>] net_tx_action+0x3c/0xe0
> [  186.700961]  [<c015c9c2>] vfs_read+0x132/0x140
> [  186.705378]  [<c015cd41>] sys_read+0x41/0x70
> [  186.709625]  [<c0102b66>] sysenter_past_esp+0x5f/0x89
> [  186.714651]  =======================
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Excellent catch:

Acked-by: David S. Miller <davem@davemloft.net>
