Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYCZCmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYCZCmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYCZCma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:42:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48541
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbYCZCm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:42:29 -0400
Date: Tue, 25 Mar 2008 19:42:21 -0700 (PDT)
Message-Id: <20080325.194221.16658596.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: yang.shi@windriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E9B39C.5010502@pobox.com>
References: <47E9B115.9060109@windriver.com>
	<47E9B39C.5010502@pobox.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Tue, 25 Mar 2008 22:23:24 -0400

> This is bogus -- you should never need to slow down the hot path in such 
> a way.

Slow down in what way?  Even on x86 saving the flags is just
about as expensive as a plain sti/cli.

I would in fact prefer to see drivers unconditionally use
spin_lock_irqsave() et al. in the interrupt handler, for
consistency.
