Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbXBSAWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbXBSAWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 19:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbXBSAWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 19:22:09 -0500
Received: from ozlabs.org ([203.10.76.45]:59128 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXBSAWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 19:22:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17880.60841.973258.612628@cargo.ozlabs.ibm.com>
Date: Mon, 19 Feb 2007 11:22:01 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 02/11] syslets: add syslet.h include file, user API/ABI definitions
In-Reply-To: <20070213142024.GC638@elte.hu>
References: <20060529212109.GA2058@elte.hu>
	<20070213142024.GC638@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> add include/linux/syslet.h which contains the user-space API/ABI
> declarations. Add the new header to include/linux/Kbuild as well.

> +struct syslet_uatom {
> +	unsigned long				flags;
> +	unsigned long				nr;
> +	long __user				*ret_ptr;
> +	struct syslet_uatom	__user		*next;
> +	unsigned long		__user		*arg_ptr[6];
> +	/*
> +	 * User-space can put anything in here, kernel will not
> +	 * touch it:
> +	 */
> +	void __user				*private;
> +};

This structure, with its unsigned longs and pointers, is going to
create enormous headaches for 32-bit processes on 64-bit machines as
far as I can see---and on ppc64 machines, almost all processes are
32-bit, since there is no inherent speed penalty for running in 32-bit
mode, and some space savings.

Have you thought about how you will handle compatibility for 32-bit
processes?  The issue will arise for x86_64 and ia64 (among others)
too, I would think.

Paul.
