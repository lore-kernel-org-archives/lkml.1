Return-Path: <linux-kernel-owner+w=401wt.eu-S1763045AbXGWSNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763045AbXGWSNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXGWSNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:13:33 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:45732 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375AbXGWSNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:13:33 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Mon, 23 Jul 2007 23:44:52 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
In-Reply-To: <alpine.LFD.0.999.0707231056260.3607@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707232338260.22796@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in>
 <alpine.LFD.0.999.0707231056260.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Linus Torvalds wrote:

> On Mon, 23 Jul 2007, Satyam Sharma wrote:
> >
> > * The "I" constraint modifier is applicable only to immediate-value operands,
> >   and combining it with "r" is bogus.
> 
> This is wrong too.
> 
> The whole point of a "Ir" modifier is to say that the instruction takes 
> *either* an "I" or an "r".

Yup, sorry about this one, Andi pointed this out earlier. But the "I"
must still go I think, for the third reason in that changelog -- it
unnecessarily limits the bit offset to 0..31, but (at least from the
comment up front in that file) we do allow arbitrarily large @nr (upto
255, of course, these instructions won't take anything greater than that).

> Andrew - the ones I've looked at were all wrong. Please don't take this 
> series.

I think I'll rescind the series anyway, a lot of patches turned out to
be wrong -- some due to mis-reading / incorrect gcc docs, others due to
other reasons ... this was just something I did thinking of as a cleanup
anyway, so I don't intend to push or correct this or anything.

Satyam
