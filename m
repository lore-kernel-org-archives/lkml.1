Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbXGWQbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbXGWQbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbXGWQbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:31:14 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:45381 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759769AbXGWQbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:31:13 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Mon, 23 Jul 2007 22:02:31 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Andi Kleen <ak@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__
 __volatile__
In-Reply-To: <200707231818.00547.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0707232157090.22155@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
 <200707231818.00547.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 23 Jul 2007, Andi Kleen wrote:

> On Monday 23 July 2007 18:06:03 Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
> > 
> > Another oddity I noticed in this file. The semantics of __volatile__
> > when used to qualify inline __asm__ are that the compiler will not
> > (1) elid, or, (2) reorder, or, (3) intersperse, our inline asm with
> > the rest of the generated code.
> > 
> > However, we do not want these guarantees in the unlocked variants of the
> > bitops functions. 
> 
> I thought so too and did a similar transformation while moving
> some string functions out of line. After that recent misadventure
> I would be very very careful with this.

Ah, ok, so this must be the case we'd stumbled upon recently on the
other thread. I hadn't got your fix for this, so didn't know.

> Overall I'm sorry to say, but the risk:gain ratio of this
> patch is imho totally out of whack.

The patch does look correct to me, we're only killing the use of
__volatile__ from places that don't require it (the guarantee-less
variants). Without losing it, I really don't see how the compiler
can ever combine multiple bitops, which does sound beneficial when
the caller has already implemented higher-level locking around
the usage of these operations.

Satyam
