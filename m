Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbXF0DdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbXF0DdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXF0DdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:33:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4217 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbXF0DdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:33:07 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 26 Jun 2007 20:33:05 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Rik van Riel <riel@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <4681D45F.7080309@redhat.com>
Message-ID: <Pine.LNX.4.64.0706262028570.26540@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
 <4681D45F.7080309@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Rik van Riel wrote:

> Davide Libenzi wrote:
> > The following patch implements the sys_brk2() syscall, that nothing is
> > other than a sys_brk() with an extra "flags" parameter. This can be used
> > to pass the new MAP_NOZERO bit, to ask the kernel to hand over non-zero
> > pages if possible.
> 
> Since programs can get back free()d memory after a malloc(),
> with the old contents of the memory intact, surely your
> MAP_NONZERO behavior could be the default for programs that
> can get away with it?
> 
> Maybe we could use some magic ELF header, similar to the
> way non-executable stack is handled?

Well, the quick&ugly glibc patch simply uses an environment variable, just 
because I wanted to bench the kernel build with using the same glibc+gcc.
Yes, it can be the default behaviour for the allocator. The patch handles 
calloc() correctly, by forcibly zeroing memory in such calls.
But other software must be taught too, to use MAP_NOZERO when they do not 
need zeroed memory. I did that for the gcc garbage collector.



- Davide


