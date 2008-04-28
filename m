Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbYD1QAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbYD1QAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934142AbYD1P7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:59:53 -0400
Received: from www.tglx.de ([62.245.132.106]:35662 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622AbYD1P7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:59:52 -0400
Date: Mon, 28 Apr 2008 17:58:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander van Heukelum <heukelum@fastmail.fm>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <1209395443.25700.1250273669@webmail.messagingengine.com>
Message-ID: <alpine.LFD.1.10.0804281757340.3261@apollo.tec.linutronix.de>
References: <1209327591.14173.74.camel@brick>   <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>   <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de> <1209395443.25700.1250273669@webmail.messagingengine.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Alexander van Heukelum wrote:
> > See patch below. It gives back the 1400 bytes on SPARC64 and other
> > platforms that have no instruction for find bit.
> 
> Hi,
> 
> I, personally, see this patch as a stopgap measure. The real problem
> is that the generic __ffs is inlined and ends up generating a lot
> of instructions.
> 
> Until the generic implementation of __ffs is fixed not to be an
> enormous inline function, this seems to be a reasonable thing
> to do, though it's a shame that the optimization is now default-
> off for architectures with a good implementation of __ffs.

Yup, it hasn't been there before and we explicitely enable it on
x86. If there are other archs which have a good one it's a nobrainer
to enable it.

Thanks,
	tglx

