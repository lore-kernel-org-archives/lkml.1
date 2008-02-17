Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbYBQOBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbYBQOBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYBQOAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:00:52 -0500
Received: from www.tglx.de ([62.245.132.106]:50142 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbYBQOAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:00:51 -0500
Date: Sun, 17 Feb 2008 15:00:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
In-Reply-To: <20080207230304.GA4352@ghostprotocols.net>
Message-ID: <alpine.LFD.1.00.0802171456450.7583@apollo.tec.linutronix.de>
References: <20080207230304.GA4352@ghostprotocols.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Arnaldo Carvalho de Melo wrote:
> Hi Ingo,
> 
> 	I'm starting with you because the first file I used to
> experiment with this idea was arch/x86/ia32/sys_ia32.c.
> 
> 	I found it strange that the struct sk_buff definition was found
> inside the DWARF debugging sections in the generated object, so I verified
> and found that there is no need for the files that bring struct sk_buff
> definition into this file and verified also that sk_buff is not brought
> in indirectly too, thru other headers.
> 
> 	I went on and removed many other unneeded includes and the end
> result is:
> 
> [acme@doppio net-2.6]$ l /tmp/sys_ia32.o.before /tmp/sys_ia32.o.after
> -rw-rw-r-- 1 acme acme 185240 2008-02-06 19:19 /tmp/sys_ia32.o.after
> -rw-rw-r-- 1 acme acme 248328 2008-02-06 19:00 /tmp/sys_ia32.o.before
> 
> 	Almost 64KB only on this object file!
> 
> 	There were no other side effects from this change:
> 
> [acme@doppio net-2.6]$ objcopy -j "text" /tmp/sys_ia32.o.before /tmp/text.before
> [acme@doppio net-2.6]$ objcopy -j "text" /tmp/sys_ia32.o.after /tmp/text.after
> [acme@doppio net-2.6]$ md5sum /tmp/text.before /tmp/text.after
> b7ac9b17942add68494e698e4f965d36  /tmp/text.before
> b7ac9b17942add68494e698e4f965d36  /tmp/text.after
> 
> 	One of the complaints about using tools such as systemtap is
> that one has to install the huge kernel-debuginfo package:
> 
> [acme@doppio net-2.6]$ rpm -q --qf "%{size}\n" kernel-rt-debuginfo
> 471737710
> 543867594
> [acme@doppio net-2.6]$
> 
> 	So I'll try to improve automation to find more of these cases.

That'd be grat.
 
> 	Here goes the first patch, regards.

Applied. Thanks,

	 tglx
