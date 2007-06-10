Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbXFJP4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbXFJP4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 11:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXFJP4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 11:56:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1117 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXFJP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 11:56:08 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 10 Jun 2007 08:56:06 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Paul Mackerras <paulus@samba.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <18027.40637.672203.14305@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0706100852220.24724@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <18026.15766.574693.200636@cargo.ozlabs.ibm.com> <463C79D8-88CB-492A-96FD-10C10D16C4B6@mac.com>
 <18027.40637.672203.14305@cargo.ozlabs.ibm.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Paul Mackerras wrote:

> > for (i = 0; i < NR_OPEN; i++)
> > 	if (!fd_is_special_to_us(i))
> > 		close(i);
> > 
> > Note that this is conceptually buggy, but occurs in several major C  
> > programming books, most of the major shells, and a lot of other  
> > software to boot.
> 
> Buggy in what way?  In the use of the NR_OPEN constant?

That is typical daemonize code done by quite a few apps, and even 
described in many unix network programming books. Now say that before that 
you loaded a library that had an internal fd allocated to get some sort of 
services from the kernel (say an epoll fd). What happens when the library 
uses the cached apoll fd after that loop?



- Davide


