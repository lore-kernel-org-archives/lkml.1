Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYHGFoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYHGFoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 01:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYHGFoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 01:44:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46875
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYHGFoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 01:44:11 -0400
Date: Wed, 06 Aug 2008 22:44:11 -0700 (PDT)
Message-Id: <20080806.224411.210555962.davem@davemloft.net>
To: guijianfeng@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix kernel panic when calling tcp_v(4/6)_md5_do_lookup
From: David Miller <davem@davemloft.net>
In-Reply-To: <489A8459.1020909@cn.fujitsu.com>
References: <489A8459.1020909@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Thu, 07 Aug 2008 13:12:57 +0800

> If the following packet flow happen, kernel will panic.
> MathineA			MathineB
> 		SYN
> 	---------------------->    
>         	SYN+ACK
> 	<----------------------
> 		ACK(bad seq)
> 	---------------------->
> When a bad seq ACK is received, tcp_v4_md5_do_lookup(skb->sk, ip_hdr(skb)->daddr))
> is finally called by tcp_v4_reqsk_send_ack(), but the first parameter(skb->sk) is 
> NULL at that moment, so kernel panic happens.
> This patch fixes this bug.
> 
> Below is the OOPS output:
 ...
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Applied, thanks.
