Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXLMNe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXLMNe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXLMNd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:33:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56358
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbXLMNdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:33:54 -0500
Date: Thu, 13 Dec 2007 05:33:54 -0800 (PST)
Message-Id: <20071213.053354.82143565.davem@davemloft.net>
To: joonwpark81@gmail.com
Cc: auke-jan.h.kok@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       jgarzik@pobox.com, shemminger@linux-foundation.org
Subject: Re: [PATCH 1/7] [NETDEV]: e1000 Fix possible causing oops of
 net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <000701c83d71$95536b10$9c94fea9@jason>
References: <000701c83d71$95536b10$9c94fea9@jason>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joonwoo Park" <joonwpark81@gmail.com>
Date: Thu, 13 Dec 2007 19:18:56 +0900

> Just blowing netif_running up is not best solution I think, it makes
> ifconfig down hang at least for e1000.

It hangs because the packet receive rate is so high that NAPI
poll never exits.

I think we need a cheap solution to something so obscure and
almost not worth explicitly even coding for.  Really, if you
setup silly situations like that, you get what you asked for.
