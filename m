Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYDWWuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYDWWuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYDWWtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:49:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41452
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbYDWWtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:49:51 -0400
Date: Wed, 23 Apr 2008 15:49:53 -0700 (PDT)
Message-Id: <20080423.154953.161012169.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: jeff@garzik.org, paulkf@microgate.com, jchapman@katalix.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <m34p9smrmp.fsf@maximus.localdomain>
References: <480E4FA1.5020508@garzik.org>
	<20080422.150559.115368150.davem@davemloft.net>
	<m34p9smrmp.fsf@maximus.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 23 Apr 2008 19:02:22 +0200

> netdev_priv() was introduced at some point in time to allow
> alloc_netdev() to optionally allocate additional memory for internal
> use by the driver. It had nothing to do with dev->priv except "priv"
> name. The drivers don't use it passing size 0.

No, it was added as an optimization since the private
area was allocated together with the struct netdev, and
thus at a constant offset computable a compile time.

It was never meant to provide a facility to have two private areas
associated with a device, but unfortunately some broken stuff decided
to use it that way.
