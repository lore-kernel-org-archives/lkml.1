Return-Path: <linux-kernel-owner+w=401wt.eu-S939709AbXFHTh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939709AbXFHTh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937752AbXFHThr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:37:47 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3627 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXFHThq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:37:46 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 8 Jun 2007 12:37:44 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ulrich Drepper <drepper@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070608203007.3c50eb66@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706081229030.5795@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com>
 <20070608203007.3c50eb66@the-village.bc.nu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Alan Cox wrote:

> On Fri, 08 Jun 2007 11:43:29 -0700
> Ulrich Drepper <drepper@redhat.com> wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Alan Cox wrote:
> > > Why does he want an unpredictable algorithm
> > 
> > To avoid exactly the kind of problem we have now in future: programs
> > relying on specific patterns.
> 
> Which you seem to think is a bad thing, yet is actually a very good thing
> because it means that crashes are repeatable and problems are debuggable
> from end user reports.
> 
> Trying to randomize filehandles for the general case is not a productive
> activity. If you want to debug cases write yourself a glibc wrapper that
> does annoying things but don't inflict it on people who actually want to
> build working, testable, debuggable systems (ie most of us)

So, what do you plan to do? Those handle won't be zero-based. Your 
"working" system I immagine will do:

	bleeh[handle - BASE].duh = ...;

How nice for a working system. If you *store* the handle returned by the 
OS, and you *use* the handle to call for OS services, you will be fine 
independently from the value handed out by the OS.



- Davide


