Return-Path: <linux-kernel-owner+w=401wt.eu-S1764996AbXGWS3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764996AbXGWS3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758401AbXGWS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:29:42 -0400
Received: from gw.goop.org ([64.81.55.164]:34832 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758352AbXGWS3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:29:41 -0400
Message-ID: <46A4F360.2000905@goop.org>
Date: Mon, 23 Jul 2007 11:28:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in> <46A4D612.9050209@goop.org> <Pine.LNX.4.64.0707232202580.22155@cselinux1.cse.iitk.ac.in> <46A4E7E3.8090105@goop.org> <Pine.LNX.4.64.0707232316440.22796@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707232316440.22796@cselinux1.cse.iitk.ac.in>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> The (3) as I had originally written / meant was that multiple
> instructions in a volatile asm would not get _individually_
> interspersed with the rest of the code i.e. be emitted out
> _consecutively_. I don't think we need any such guarantees for
> the non-atomic variants of those operations, so it's good to
> let the compiler have a free hand with what it wants to do,
> and optimize/combine multiple bitops as necessary / possible,
> which was the original intention.
>   

No, a single asm statement is always emitted in one piece.  Gcc doesn't
parse the string other than to do %-substitution to insert arguments, so
it has no way to meaningfully split it up.

    J
