Return-Path: <linux-kernel-owner+w=401wt.eu-S970030AbXFHTvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970030AbXFHTvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXFHTvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:51:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3159 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXFHTvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:51:07 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 8 Jun 2007 12:51:05 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ulrich Drepper <drepper@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070608204836.5adaefa7@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706081246360.5795@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com>
 <20070608203007.3c50eb66@the-village.bc.nu> <Pine.LNX.4.64.0706081229030.5795@alien.or.mcafeemobile.com>
 <20070608204836.5adaefa7@the-village.bc.nu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Alan Cox wrote:

> > So, what do you plan to do? Those handle won't be zero-based. Your 
> > "working" system I immagine will do:
> > 
> > 	bleeh[handle - BASE].duh = ...;
> > 
> > How nice for a working system. If you *store* the handle returned by the 
> > OS, and you *use* the handle to call for OS services, you will be fine 
> > independently from the value handed out by the OS.
> 
> Well there are two ways I'd do this
> 
> #1: Throw the whole thing away and accept its not a good idea anyway

Unfortunately (exactly because of the same guarantees you're asking for 
those handles), in order for userspace libraries to reliably internally 
use fds to interact with the kernel, you need another kind of allocation 
strategy.



> #2: If I was really going this way and I wanted to use it for serious
> tricks for high performance I/O then I'd provide the handle from
> userspace so that the strategy for allocation is controlled by the caller
> who is the only one who can make the smart decisions

It does not work. What if the main application, library A and library B 
wants to implement their own allocation strategy?



- Davide


