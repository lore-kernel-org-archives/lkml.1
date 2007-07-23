Return-Path: <linux-kernel-owner+w=401wt.eu-S1765264AbXGWSvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765264AbXGWSvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbXGWSvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:51:12 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:49189 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760150AbXGWSvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:51:11 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 24 Jul 2007 00:22:30 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
In-Reply-To: <46A4F5EF.8010402@zytor.com>
Message-ID: <Pine.LNX.4.64.0707240016390.22796@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in>
 <alpine.LFD.0.999.0707231056260.3607@woody.linux-foundation.org>
 <46A4F5EF.8010402@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, H. Peter Anvin wrote:

> Linus Torvalds wrote:
> > 
> > On Mon, 23 Jul 2007, Satyam Sharma wrote:
> >> * The "I" constraint modifier is applicable only to immediate-value operands,
> >>   and combining it with "r" is bogus.
> > 
> > This is wrong too.
> > 
> > The whole point of a "Ir" modifier is to say that the instruction takes 
> > *either* an "I" or an "r".
> > 
> > Andrew - the ones I've looked at were all wrong. Please don't take this 
> > series.
> > 
> 
> Incidentally, I just noticed the x86-64 bitops have "dIr" as their
> constraint set.  "d" would normally be redundant with "r", and as far as
> I know, gcc doesn't prefer one over the other without having "?" or "!"
> as part of the constraint, so is is "d" a stray or is there some meaning
> behind it?


Yup, I had noticed that myself. We would need to use "J" if we want
to limit the offsets to 0..63, but "d" sounds weird / stray indeed,
unless there's yet another undocumented/wrongly-documented mystery
behind this one too ... (I'd like to know even if that's the case,
obviously).

Satyam
