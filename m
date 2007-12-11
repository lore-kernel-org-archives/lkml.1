Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbXLKBSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbXLKBSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXLKBSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:18:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52106
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbXLKBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:18:00 -0500
Date: Mon, 10 Dec 2007 17:17:59 -0800 (PST)
Message-Id: <20071210.171759.78444664.davem@davemloft.net>
To: julia@diku.dk
Cc: fpavlic@de.ibm.com, wangchen@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix use of skb after netif_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0712092103560.11165@ask.diku.dk>
References: <Pine.LNX.4.64.0712092103560.11165@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 9 Dec 2007 21:05:30 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> Recently, Wang Chen submitted a patch
> (d30f53aeb31d453a5230f526bea592af07944564) to move a call to netif_rx(skb)
> after a subsequent reference to skb, because netif_rx may call kfree_skb on
> its argument.  netif_rx_ni calls netif_rx, so the same problem occurs in
> the files below.
> 
> I have left the updating of dev->last_rx after the calls to netif_rx_ni
> because it seems time dependent, but moved the other field updates before.
> 
> This was found using the following semantic match.
> (http://www.emn.fr/x-info/coccinelle/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
