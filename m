Return-Path: <linux-kernel-owner+w=401wt.eu-S1031199AbXFHSLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031199AbXFHSLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969757AbXFHSL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:11:27 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3441 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965636AbXFHSL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:11:26 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 8 Jun 2007 11:11:24 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070608140150.6f31672f@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Alan Cox wrote:

> > Um, how cheap do you need it?  get_random_int() is actually pretty
> > cheep, since it was designed to be usable by the networking stack for
> > sequence numbers for TCP packets; and it's not like sys_close() or
> > sys_open() is a majorly critical path, is it?  If the concern is
> 
> At this point wouldn't it be cheaper to allocate file handles using a
> different algorithm than firing up the RNG - say like in the POSIX
> fashion ... 

The only reason we use a floating base, is because Uli preferred to have 
non-exactly predictable fd allocations. There no reason of re-doing the 
same POSIX mistake all over again:

Errare humanum est, perseverare autem diabolicum


- Davide


