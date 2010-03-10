Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0CJKah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:30:37 -0500
Received: from borg.medozas.de ([188.40.89.202]:36507 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab0CJKaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:30:35 -0500
Date: Wed, 10 Mar 2010 11:30:32 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: suresh.b.siddha@intel.com, hpa@zytor.com
Subject: Re: page_to_nid not linked in on PAE
In-Reply-To: <alpine.LSU.2.01.1003091210230.10157@obet.zrqbmnf.qr>
Message-ID: <alpine.LSU.2.01.1003101128340.9318@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1003091210230.10157@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 2010-03-09 13:32, Jan Engelhardt wrote:
>
>I have here a compile error with 2.6.33 related to some change in
>page flags. The offending commit, according to bisect, is
>
>commit 46cf98cdaef5471926010b5bddf84c44ec177fdd
>
>    x86, pat: Generalize the use of page flag PG_uncached
>    
>$ make ARCH=i386 vmlinux
> ...
>  LD      .tmp_vmlinux1
>arch/x86/built-in.o: In function `dma_generic_alloc_coherent':
>(.text+0x42b2): undefined reference to `page_to_nid'
...

Due to the addition of page flags (like in the commit above),
there are less bits to encode the node.
In other words, reducing CONFIG_NODES_SHIFT works around the problem.
But that can't really be a terminal solution.

>CONFIG_NODES_SHIFT=7
