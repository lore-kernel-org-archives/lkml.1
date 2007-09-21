Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbXIUNQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbXIUNQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXIUNQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:16:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48799 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXIUNQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:16:34 -0400
Date: Fri, 21 Sep 2007 15:16:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Add CRC checksum for RCU lists
In-Reply-To: <20070921140221.000a416a@twins>
Message-ID: <Pine.LNX.4.64.0709211516060.30810@fbirervta.pbzchgretzou.qr>
References: <1190313251.4518.14.camel@localhost.localdomain>
 <20070921140221.000a416a@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 21 2007 14:02, Peter Zijlstra wrote:
>> +	if (unlikely(head->crc != rcu_crc_calc(head)) && !once) {
>> +		once++;
>> +		printk("BUG: RCU check failed!");
>> +		if (head->caller)
>> +			printk(" (caller=%p)",
>> +			       head->caller);
>
>		char sym[KSYM_SYMBOL_LEN];
>		sprint_symbol(sym, head->caller);
>		printk(" (caller: [<%p>] %s)", head->caller, sym);

This has been wondering me some time. Kernel oopses also use [<%p>],
but what really for are two sort of braces needed?

