Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbYFUI4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbYFUI4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYFUI4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:56:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44303 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYFUI4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:56:40 -0400
Date: Sat, 21 Jun 2008 17:56:17 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [Experimental][PATCH] putback_lru_page rework
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
In-Reply-To: <1213994489.6474.127.camel@lts-notebook>
References: <1213981843.6474.68.camel@lts-notebook> <1213994489.6474.127.camel@lts-notebook>
Message-Id: <20080621175458.E82A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quick update:  
> 
> With this patch applied, at ~ 1.5 hours into the test, my system panic'd
> [panic_on_oops set] with a BUG in __find_get_block() -- looks like the
> BUG_ON() in check_irqs_on() called from bh_lru_install() inlined by
> __find_get_block().  Before the panic occurred, I saw warnings from
> native_smp_call_function_mask() [arch/x86/kernel/smp.c]--also because
> irqs_disabled().
> 
> I'll back out the changes [spin_[un]lock() => spin_[un]lock_irq()] to
> shrink_inactive_list() and try again.  Just a hunch.

Yup.
Kamezawa-san's patch remove local_irq_enable(), but don't remove
local_irq_disable().
thus, irq is never enabled.

> -	spin_unlock(&zone->lru_lock);
> +	spin_unlock_irq(&zone->lru_lock);
>  done:
> -	local_irq_enable();



