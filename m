Return-Path: <linux-kernel-owner+w=401wt.eu-S934098AbXGWSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098AbXGWSGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763278AbXGWSGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:06:36 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:57987 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbXGWSGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:06:33 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Mon, 23 Jul 2007 23:37:51 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__
 __volatile__
In-Reply-To: <46A4E7E3.8090105@goop.org>
Message-ID: <Pine.LNX.4.64.0707232316440.22796@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A4D612.9050209@goop.org> <Pine.LNX.4.64.0707232202580.22155@cselinux1.cse.iitk.ac.in>
 <46A4E7E3.8090105@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Jeremy Fitzhardinge wrote:

> I'm not quite sure what your point is.

Could be a case of terminology confusion ...

> The paragraph you quoted is
> pretty explicit in saying that volatile doesn't prevent an "asm
> volatile" from being interspersed with other code, and the example just
> before that is explicit in talking about how to use dependencies to
> control the ordering of asm volatiles with respect to surrounding code.

Yes, that was the (2).

> In fact nothing in that section precludes asm volatiles from being
> reordered with respect to each other either; you just have to make sure
> your dependency constraints are all correct.

The (3) as I had originally written / meant was that multiple
instructions in a volatile asm would not get _individually_
interspersed with the rest of the code i.e. be emitted out
_consecutively_. I don't think we need any such guarantees for
the non-atomic variants of those operations, so it's good to
let the compiler have a free hand with what it wants to do,
and optimize/combine multiple bitops as necessary / possible,
which was the original intention.

Satyam
