Return-Path: <linux-kernel-owner+w=401wt.eu-S1751139AbZKCFQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbZKCFQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZKCFQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:16:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48353
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbZKCFQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:16:16 -0500
Date: Mon, 02 Nov 2009 21:16:40 -0800 (PST)
Message-Id: <20091102.211640.184762927.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, fweisbec@gmail.com, vince@simtec.co.uk,
       jkacur@redhat.com, corbet@lwn.net, hch@infradead.org
Subject: Re: [patch 18/28] watchdog: Remove BKL from rio watchdog driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091010153349.804244057@linutronix.de>
References: <20091010153314.827301943@linutronix.de>
	<20091010153349.804244057@linutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 10 Oct 2009 15:36:48 -0000

> cycle_kernel_lock() was added with the BKL pushdown. The rio driver
> indeed needs that because riowd_device is initialized after
> misc_register(). So an open(), write/ioctl() which happens to get
> between misc_register returning and riowd_device initialization would
> dereference a NULL pointer.
> 
> Move riowd_device initialization before misc_register() and get rid of
> cycle_kernel_lock().
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Also applied to sparc-next-2.6, thanks!
