Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYD2W6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYD2W6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYD2W60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:58:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34215
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbYD2W6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:58:25 -0400
Date: Tue, 29 Apr 2008 15:58:24 -0700 (PDT)
Message-Id: <20080429.155824.183713623.davem@davemloft.net>
To: tglx@linutronix.de
Cc: torvalds@linux-foundation.org, harvey.harrison@gmail.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops: remove "optimizations"
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804291843550.6003@apollo.tec.linutronix.de>
References: <20080429.030332.88897602.davem@davemloft.net>
	<20080429.053412.15412725.davem@davemloft.net>
	<alpine.LFD.1.10.0804291843550.6003@apollo.tec.linutronix.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 29 Apr 2008 18:51:51 +0200 (CEST)

> The question is, whether it broke things or just unearthed some bug
> hidden elsewhere.

So I did a quick test, just #if 0'ing out the optimization inline
portions of the find_first_bit() code in linux/bitops.h, and forcing
it to always unconditionally call __find_first_bit() fixes the
regression.

Given that others who tested could not find one case where the
optimization cases actually applied, and it's breaking things for me,
my theory is that it's triggering for some obscure case on sparc64 and
thus showing a bug in these optimizations since in practice I'm the
only person to actually test this new code.
