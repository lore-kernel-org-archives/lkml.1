Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbZJNIUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbZJNIUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbZJNIUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:20:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39402
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757904AbZJNIUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:20:01 -0400
Date: Wed, 14 Oct 2009 01:19:57 -0700 (PDT)
Message-Id: <20091014.011957.96735570.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, fweisbec@gmail.com, vince@simtec.co.uk,
       jkacur@redhat.com, corbet@lwn.net, hch@infradead.org,
       herbert@gondor.apana.org.au
Subject: Re: [patch 03/28] net: Remove BKL from tun
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091010153349.154442560@linutronix.de>
References: <20091010153314.827301943@linutronix.de>
	<20091010153349.154442560@linutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 10 Oct 2009 15:35:33 -0000

> The lock_kernel/unlock_kernel() in cycle_kernel_lock() which is called
> in tun_chr_open() is not serializing against anything and safe to
> remove.
> 
> tun_chr_fasync() is serialized by get/put_tun() and fasync_helper()
> has no dependency on BKL. The modification of tun->flags is racy with
> and without the BKL so removing it does not make it worse.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied to net-next-2.6, thanks!
