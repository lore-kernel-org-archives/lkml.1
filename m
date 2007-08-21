Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbXHUAJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbXHUAJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 20:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXHUAJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 20:09:07 -0400
Received: from ozlabs.org ([203.10.76.45]:36578 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXHUAJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 20:09:06 -0400
Subject: Re: [patch 2/2] Sort module list by pointer address to get
	coherent sleepable seq_file iterators
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070820202646.555561265@polymtl.ca>
References: <20070820202600.116795129@polymtl.ca>
	 <20070820202646.555561265@polymtl.ca>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 10:08:29 +1000
Message-Id: <1187654910.19435.147.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 16:26 -0400, Mathieu Desnoyers wrote:
> plain text document attachment (module.c-sort-module-list.patch)
> A race that appears both in /proc/modules and in kallsyms: if, between the
> seq file reads, the process is put to sleep and at this moment a module is
> or removed from the module list, the listing will skip an amount of
> modules/symbols corresponding to the amount of elements present in the unloaded
> module, but at the current position in the list if the iteration is located
> after the removed module.
> 
> The cleanest way I found to deal with this problem is to sort the module list.
> We can then keep the old struct module * as the old iterator, knowing the it may
> be removed between the seq file reads, but we only use it as "get next". If it
> is not present in the module list, the next pointer will be used.
> 
> By doing this, removing a given module will now only fuzz the output related to
> this specific module, not any random module anymore. Since modprobe uses
> /proc/modules, it might be important to make sure multiple concurrent running
> modprobes won't interfere with each other.

You've reduced, but not eliminated, the problem.  A new module inserted
is quite likely to reuse the same address.

I don't have a real problem with this patch, but I'm wondering if the
problem is theoretical or demonstrated.

Rusty.


