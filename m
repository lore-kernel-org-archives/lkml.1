Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0BAKAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:00:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48369
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab0BAKAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:00:42 -0500
Date: Mon, 01 Feb 2010 02:00:55 -0800 (PST)
Message-Id: <20100201.020055.57470143.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       eric.dumazet@gmail.com
Subject: Re: [Patch v2] net: export TCP send buffer size via netlink
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100201092153.4194.91507.sendpatchset@localhost.localdomain>
References: <20100201092153.4194.91507.sendpatchset@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Mon, 1 Feb 2010 04:18:28 -0500

> V1 -> V2:
> Keep ABI compatiblity of struct tcp_info.
> 
> Currently, we can only get TCP send buffer size by
> getsockopt (SO_SNDBUF or TCP_INFO), this is not enough
> for the tools like netstat or ss to read.
> 
> Show TCP send buffer size via netlink NETLINK_INET_DIAG.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

If the user has a "struct tcp_info info" on it's stack,
and it's compiled against the header file before your
changes, guess what the kernel is going to do?

It's going to write past the end of the user's variable
into random stack locations.

You can't change the layout, at all.
