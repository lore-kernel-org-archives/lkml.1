Return-Path: <linux-kernel-owner+w=401wt.eu-S966794AbXFHAEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966794AbXFHAEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXFHAEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:04:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2012 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXFHAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:04:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 17:04:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <alpine.LFD.0.98.0706071642000.4205@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706071645000.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706071521490.6445@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0706071642000.4205@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Linus Torvalds wrote:

> 
> 
> On Thu, 7 Jun 2007, Davide Libenzi wrote:
> > 
> > We'd still need sys_nonseqfd() though, to move/dup legacy fds into the 
> > non-sequential area.
> 
> Umm. No we don't. Because it's no more than 
> 
> 	indirect_syscall(dup, FD_NONSEQ)
> 
> isn't it?

Hmm, ok. It need some changes since sys_dup() and F_DUPFD uses common code 
at the moment, but it'd ok.
Basically, everything that calls get_unused_fd() can get the magic 
indirect_syscall() settings. I was just planning to localize the 
sequential/non-sequential behaviour just in there.
The sys_dup(), sys_dup2() and F_DUPFD have some custom code, although 
sys_dup() should really use get_unused_fd() in any way.



- Davide


