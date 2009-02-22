Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbZBVWnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbZBVWnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZBVWni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:43:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:47793 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZBVWnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:43:37 -0500
Subject: Re: Lock-up on PPC64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: malc <av1474@comtv.ru>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0902221126220.3111@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
	 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
	 <20081223234513.GA8730@deepthought> <871vvy77v4.fsf@linmac.oyster.ru>
	 <1230165163.7292.32.camel@pasglop>
	 <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
	 <1231158516.8367.3.camel@localhost>
	 <Pine.LNX.4.64.0901051928200.2208@linmac.oyster.ru>
	 <1231243373.14860.24.camel@pasglop>
	 <Pine.LNX.4.64.0901062032550.2972@linmac.oyster.ru>
	 <1231276643.14860.30.camel@pasglop>
	 <Pine.LNX.4.64.0901070105510.4695@linmac.oyster.ru>
	 <Pine.LNX.4.64.0902221126220.3111@linmac.oyster.ru>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 09:42:45 +1100
Message-Id: <1235342565.8805.216.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-22 at 11:35 +0300, malc wrote:
> After writing valgrind tool that was simulating Cell XER.SO syscall
> (mis)behaviour (pre ab598b6680f1e74c267d1547ee352f3e1e530f89 that is)
> and banging my had against the wall for a while trying to figure out
> which of the failing syscalls was responsible, i've tried to be simple
> and after only ~30 minutes came up with this, rather short, piece of
> code that knocks pre XER.SO patched kernels out cold:
> 
> gcc -o xer -x assembler /dev/stdin -nostdlib <<eof
> .globl _start
> _start:
>          addis 0,0,0x8000
>          mtxer 0
>          addi 0,0,1
>          sc

Allright, but the XER patch fixes it... interesting. Oh well, I'll try
to figure out at some stage where we get something wrong in those old
kernels.

Cheers,
Ben.



