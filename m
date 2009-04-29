Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZD2FMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZD2FMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZD2FMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:12:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57600
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbZD2FMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:12:34 -0400
Date: Tue, 28 Apr 2009 22:12:28 -0700 (PDT)
Message-Id: <20090428.221228.217954247.davem@davemloft.net>
To: rdreier@cisco.com
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, h.mitake@gmail.com,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <adak55438gp.fsf_-_@cisco.com>
References: <49EE37AF.4020507@zytor.com>
	<20090421.173123.191021055.davem@davemloft.net>
	<adak55438gp.fsf_-_@cisco.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 28 Apr 2009 12:05:10 -0700

> As discussed in <http://lkml.org/lkml/2009/4/19/164> and follow-ups,
> readq()/writeq() for 32-bit x86 are implemented as two readl()/writel()
> operations.  This is not atomic (in the sense that another MMIO
> operation from another CPU or thread can be done in the middle of the
> two read/writes), and may not access the two halves of the register in
> the correct order to work with hardware.
> 
> Rather than silently providing a 32-bit fallback that leaves a
> possibility for strange driver bugs, it's better to provide readq()
> and writeq() only for 64-bit architectures, and have a compile failure
> on 32-bit architectures that forces driver authors to think about what
> the correct solution is.
> 
> This essentially reverts 2c5643b1 ("x86: provide readq()/writeq() on
> 32-bit too") and follow-on commits.  If in the future someone wants to
> provide a generic solution for all 32-bit architectures, that's great,
> but there's not much point in providing (arguably broken)
> implementations for only one architecture, since any portable driver
> will have to implement fallbacks for other architectures anyway.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Acked-by: David S. Miller <davem@davemloft.net>
