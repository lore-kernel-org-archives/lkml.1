Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbXGWRuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbXGWRuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760966AbXGWRuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:50:37 -0400
Received: from gw.goop.org ([64.81.55.164]:53038 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbXGWRug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:50:36 -0400
Message-ID: <46A4EA37.7020802@goop.org>
Date: Mon, 23 Jul 2007 10:49:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <200707231813.26859.ak@suse.de> <Pine.LNX.4.64.0707232152250.22155@cselinux1.cse.iitk.ac.in> <200707231833.20678.ak@suse.de> <Pine.LNX.4.64.0707232220130.22796@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707232220130.22796@cselinux1.cse.iitk.ac.in>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Exactly, but the actual _synchronization_ in all users of the bitops API
> should (should, at least, otherwise the bugs lie in the callers) depend
> upon the _bit-string_ whose address is passed to us. That could be some
> flags/lock/etc in some caller, whatever, but all the synchronization in
> those users would be based upon _that_ -- and we're handling it alright
> with the full CPU barrier for _that_ address. Also note that in all the
> atomic/unatomic variants, we always constrain the passed pointer to
> memory and for the atomic/locked variants at least, I don't really see
> how compiler optimizations would get us into trouble (again, for the
> _passed bit-string memory address_).
>   

The compiler doesn't know how large the object at that address is, so
there's limits to how much alias analysis it can do.  If it assumes
you're passing a pointer to a single word then it may fail to order the
bit operation correctly with respect to another operation on another
part of the same bitfield (a memset to clear it, for example).

    J
