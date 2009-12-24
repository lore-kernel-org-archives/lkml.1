Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZLXFys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZLXFys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 00:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZLXFyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 00:54:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55069
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbZLXFyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 00:54:46 -0500
Date: Wed, 23 Dec 2009 21:54:48 -0800 (PST)
Message-Id: <20091223.215448.241930752.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: rl@hellgate.ch, wrar@altlinux.org, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/via-rhine: Fix scheduling while atomic bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091222173641.GA3093@del.dom.local>
References: <20091222150045.GA5355@wrars-comp.wrarsdomain>
	<20091222152658.GA16043@core.hellgate.ch>
	<20091222173641.GA3093@del.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Tue, 22 Dec 2009 18:36:42 +0100

> There are BUGs "scheduling while atomic" triggered by the timer
> rhine_tx_timeout(). They are caused by calling napi_disable() (with
> msleep()). This patch fixes it by moving most of the timer content to
> the workqueue function (similarly to other drivers, like tg3), with
> spin_lock() changed to BH version.
> 
> Additionally, there is spin_lock_irq() moved in rhine_close() to
> exclude napi_disable() etc., also tg3's way.
> 
> Reported-by: Andrey Rahmatullin <wrar@altlinux.org>
> Tested-by: Andrey Rahmatullin <wrar@altlinux.org>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>

Applied, thanks!
