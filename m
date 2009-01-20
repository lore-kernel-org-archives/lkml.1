Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbZATWr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbZATWr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZATWrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:47:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40159
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755521AbZATWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:47:18 -0500
Date: Tue, 20 Jan 2009 14:47:19 -0800 (PST)
Message-Id: <20090120.144719.120709836.davem@davemloft.net>
To: arnd@arndb.de
Cc: ceggers@gmx.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] usb/mcs7830: Don't use buffers from stack for USB
 transfers
From: David Miller <davem@davemloft.net>
In-Reply-To: <200901202345.47792.arnd@arndb.de>
References: <34115.192.168.0.40.1232483361.squirrel@server>
	<200901202345.47792.arnd@arndb.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 20 Jan 2009 23:45:47 +0100

> On Tuesday 20 January 2009, you wrote:
> > From: Christian Eggers <christian.eggers@kathrein.de>
> > 
> > mcs7830_set_reg() and mcs7830_get_reg() are called with buffers
> > from stack which must not be used directly for USB transfers.
> > This causes corruption of the stack particulary on non x86
> > architectures because DMA may be used for these transfers.
> > 
> > Signed-off-by: Christian Eggers <christian.eggers@kathrein.de>
> 
> Have you observed problems with this, or just suspected trouble?

Yes, this is in response to SH platform failures.

You cannot DMA from/to the kernel stack, because it might not be in
the aliased linear mapping of physical memory.  It could even be
vmalloc()'d memory on some platforms.
