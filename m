Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbXFIRA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbXFIRA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXFIRAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:00:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4093 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXFIRAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:00:49 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 9 Jun 2007 10:00:44 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Paul Mackerras <paulus@samba.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <18026.15766.574693.200636@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0706090942210.14037@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <18026.15766.574693.200636@cargo.ozlabs.ibm.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Paul Mackerras wrote:

> Davide Libenzi writes:
> 
> > The only reason we use a floating base, is because Uli preferred to have 
> > non-exactly predictable fd allocations. There no reason of re-doing the 
> > same POSIX mistake all over again:
> 
> Why must everything that makes things a bit simpler and more
> predictable for application programmers be called a "mistake"?

Because if you give guarantees on something, ppl start using such 
guarantee in the wrong way. Kyle's email summarizes it.
This should really be treated as an opaque handle, with no assumption on 
its value. And if you start handing over values that are not predictable, 
the userspace is *forced* to not use any assumption on its values. I never 
made any assumption on values returned by APIs returning "handles", and I 
never had any problem (or even care) about how those values were 
distributed in the N bit space.


- Davide


