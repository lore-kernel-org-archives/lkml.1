Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYCZDa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYCZDa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYCZDas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:30:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56604
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbYCZDar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:30:47 -0400
Date: Tue, 25 Mar 2008 20:30:43 -0700 (PDT)
Message-Id: <20080325.203043.196469543.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: yang.shi@windriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E9BF7B.3030003@pobox.com>
References: <47E9B39C.5010502@pobox.com>
	<20080325.194221.16658596.davem@davemloft.net>
	<47E9BF7B.3030003@pobox.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Tue, 25 Mar 2008 23:14:03 -0400

> David Miller wrote:
> > From: Jeff Garzik <jgarzik@pobox.com>
> > Date: Tue, 25 Mar 2008 22:23:24 -0400
> > 
> >> This is bogus -- you should never need to slow down the hot path in such 
> >> a way.
> > 
> > Slow down in what way?  Even on x86 saving the flags is just
> > about as expensive as a plain sti/cli.
> 
> Replacing spin_lock() [current 8139too.c] with spin_lock_irqsave() 
> results in a larger interrupt handler... more CPU instructions for the 
> same result.

Jeff, please be realistic.

These interrupt handlers about to do a PIO on a status register, which
will consume on the order of a few hundred cpu cycles.

Counting an I-cache line or two, or 18 cycles here or there,
is immaterial by comparison.
