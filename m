Return-Path: <linux-kernel-owner+w=401wt.eu-S965922AbXFGTt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965922AbXFGTt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965143AbXFGTtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:49:13 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4019 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073AbXFGTtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:49:11 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 12:49:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070607151243.22caab9e.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com>
 <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
 <20070607151243.22caab9e.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Eric Dumazet wrote:

> Davide, are you sure we want FIFO for non sequential allocations ?
> 
> This tends to use all the fmap slots, and not very cache friendly
> if an app does a lot of [open(),...,close()] things. We already got a 
> perf drop because of RCUification of file freeing (FIFO mode instead 
> of LIFO given by kmalloc()/kfree())
> 
> If the idea behind this FIFO was security (ie not easy for an app to predict 
> next glibc file handle), we/glibc might use yet another FD_SECUREMODE flag, 
> wich ORed with O_NONSEQFD would ask to fdmap_newfd() to take the tail of 
> fmap->slist, not head.

Uli, would it be OK to rely only on base randomization and use a LIFO 
instead? We have base randomization, plus LIFO does not mean strictly 
sequential like legacy allocator, just more compatc and cache friendly.



- Davide


