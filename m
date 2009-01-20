Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbZATXX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbZATXX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbZATXXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:23:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40309
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756577AbZATXXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:23:43 -0500
Date: Tue, 20 Jan 2009 15:23:45 -0800 (PST)
Message-Id: <20090120.152345.78877396.davem@davemloft.net>
To: arnd@arndb.de
Cc: ceggers@gmx.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] usb/mcs7830: Don't use buffers from stack for USB
 transfers
From: David Miller <davem@davemloft.net>
In-Reply-To: <200901210017.19038.arnd@arndb.de>
References: <200901202345.47792.arnd@arndb.de>
	<20090120.144719.120709836.davem@davemloft.net>
	<200901210017.19038.arnd@arndb.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 21 Jan 2009 00:17:18 +0100

> On Tuesday 20 January 2009, David Miller wrote:
> > +       buffer = kmalloc(size, GFP_NOIO);
> 
> GFP_NOIO seems out of place in a network driver: there is nothing
> wrong with waiting for I/O here, so plain GFP_KERNEL should be fine.

There seems to be a large precendence for this in other USB drivers,
both for networking and storage.  Probably a mutex or other locking
hierarchy issue.

Really, I would just apply this patch as-is.  It works, it's pretty
clean, and every retort has been a misunderstanding or extreme
nit-picking :-)
