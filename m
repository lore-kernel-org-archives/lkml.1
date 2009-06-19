Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbZFTBVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbZFTBVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbZFTBVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:21:31 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3159 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760825AbZFTBVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:21:30 -0400
Subject: Re: [PATCH] kmemleak: use pr_fmt
From: Joe Perches <joe@perches.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1245405220.12653.25.camel@pc1117.cambridge.arm.com>
References: <1245341337.29927.8.camel@Joe-Laptop.home>
	 <1245405220.12653.25.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 12:49:42 -0700
Message-Id: <1245440992.6201.17.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 10:53 +0100, Catalin Marinas wrote:
> Thanks for the patch. It missed one pr_info case (actually invoked via
> the pr_helper macro).

This change will affect the seq_printf uses.
Some think the seq output should be immutable.
Perhaps that's important to you or others.

An option is to change the print_helper
pr_info to a printk(KERN_INFO and not change
any uses of print_helper

#define print_helper(seq, x...)	do {	\
	struct seq_file *s = (seq);	\
	if (s)				\
		seq_printf(s, x);	\
	else				\
		printk(KERN_INFO x);	\
} while (0)

> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > + 
>    ^ - empty space at the end of the line (git told me about it)

Thanks for letting me know.  I'll fix my tools.

Joe


