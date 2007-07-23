Return-Path: <linux-kernel-owner+w=401wt.eu-S1764507AbXGWRNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764507AbXGWRNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbXGWRNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:13:46 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:57937 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362AbXGWRNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:13:45 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Mon, 23 Jul 2007 22:45:04 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Andi Kleen <ak@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jh@suse.cz
Subject: Re: [PATCH 3/8] i386: bitops: Rectify bogus "+m" constraints
In-Reply-To: <200707231837.27592.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0707232242340.22796@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160543.22137.9416.sendpatchset@cselinux1.cse.iitk.ac.in>
 <200707231837.27592.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Andi Kleen wrote:

> On Monday 23 July 2007 18:05:43 Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [3/8] i386: bitops: Rectify bogus "+m" constraints
> > 
> > From the gcc manual:
> > 
> >   Extended asm supports input-output or read-write operands. Use the
> >   constraint character `+' to indicate such an operand and list it with
> >   the output operands. You should only use read-write operands when the
> >   constraints for the operand (or the operand in which only some of the
> >   bits are to be changed) allow a register.
> > 
> > So, using the "+" constraint modifier for memory, like "+m" is bogus.
> > We must simply specify "=m" which handles the case correctly.
> 
> I checked with Honza (cc'ed) and he stated that the + are really needed
> at least in newer gcc.


That extract is from the latest (4.2.1) manual, but they could've
forgotten to update the documentation, of course.

But even then, I'm not sure they could ever make it "really needed",
that'll be a step that would break all existing code, otherwise! :-)

Satyam
