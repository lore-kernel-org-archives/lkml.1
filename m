Return-Path: <linux-kernel-owner+w=401wt.eu-S971127AbXFHWjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971127AbXFHWjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970757AbXFHWi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:38:56 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1321 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031165AbXFHWiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:38:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 8 Jun 2007 15:38:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ulrich Drepper <drepper@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070608232859.37be1902@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706081533430.5795@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com>
 <20070608203007.3c50eb66@the-village.bc.nu> <Pine.LNX.4.64.0706081229030.5795@alien.or.mcafeemobile.com>
 <20070608204836.5adaefa7@the-village.bc.nu> <Pine.LNX.4.64.0706081246360.5795@alien.or.mcafeemobile.com>
 <20070608222437.540bd8a6@the-village.bc.nu> <Pine.LNX.4.64.0706081448330.5795@alien.or.mcafeemobile.com>
 <20070608232859.37be1902@the-village.bc.nu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Alan Cox wrote:

> > > > It does not work. What if the main application, library A and library B 
> > > > wants to implement their own allocation strategy?
> > > 
> > > Its called "discipline". I would suggest that libc contains a default
> > > allocator. You might also want to assign library and application ranges
> > > for clarity.
> > 
> > That is really nice solution. Each library has to have each own allocator. 
> 
> Are you being deliberately stupid ?
> 
> I suggested *libc* contains a default allocator

"You might also want to assign library and application ranges for clarity."

So let's see. We have the legacy one (1st fdtable), the non-legacy app one 
(2nd fdtable) and one for the library (3rd fdtable). And which library? 
Each one his own (4th, 5th ... fdtable)? ...



> > replicated all around the code that access directly the fdtables. I did 
> > the fdmap consolidation patch, and I can tell you there are quite a few 
> > places that access fdtables directly.
> 
> This is true, but if you are worried about complexity we get back to the
> original posix allocator which packs them in tight and produces a most
> excellent spread in the general case (whacko apps like bash aside)

... complexity does not come from the allocator, but from the fact that 
direct access to the fdtable is done all over the kernel. Code that 
assumes there's only *one* fdtable.



- Davide


