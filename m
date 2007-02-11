Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXBKEyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXBKEyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 23:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbXBKEyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 23:54:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3596 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbXBKEx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 23:53:59 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Feb 2007 20:53:52 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ralf Baechle <ralf@linux-mips.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: -mm merge plans for 2.6.21
In-Reply-To: <20070210213447.GB9116@linux-mips.org>
Message-ID: <Pine.LNX.4.64.0702102035330.21239@alien.or.mcafeemobile.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
 <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org>
 <1171058342.29713.136.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com>
 <20070210102205.GB8145@osiris.boeblingen.de.ibm.com>
 <1171103527.29713.228.camel@pmac.infradead.org> <20070210213447.GB9116@linux-mips.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007, Ralf Baechle wrote:

> Unfortunately struct epoll_event contains a gap so it bets on identical
> padding rules between native and compat ABI and anyway, padding is wasted
> space so the struct members should have been swapped when this structure
> was created.  Oh well, too late.

You really should have needed padding in there, since even if you swapped 
the members, sizeof(struct epoll_event) would still need to be 16, if 
alignof(u64) == 8. Either adding an extra auxilliary u32, or make the two 
members be u64, would have been ok.
I'll be posting a patch that adds the compat_ layer for epoll in 
kernel/compat.c. Architectures that needs it (currently only ARM-EABI and 
IA64 use a compat code for epoll), should wire them up.



- Davide


