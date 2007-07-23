Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbXGWS3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbXGWS3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbXGWS3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:29:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42900 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbXGWS3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:29:07 -0400
Message-ID: <46A4F365.50708@zytor.com>
Date: Mon, 23 Jul 2007 11:28:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jh@suse.cz
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <200707231810.08445.ak@suse.de> <Pine.LNX.4.64.0707232145270.22155@cselinux1.cse.iitk.ac.in> <200707231830.40331.ak@suse.de> <46A4EDDD.7010309@zytor.com>
In-Reply-To: <46A4EDDD.7010309@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> "I" is correct.  The Intel documentation on this is highly confusing
> (and has bugs in it), but it does unambiguously state:
> 
> "Some assemblers support immediate bit offsets larger than 31 by using
> the immediate bit offset field in combination with the displacement
> field in the memory operand ... The processor will ignore the high-order
> bits if they are not zero."  AMD processors might be different for all I
> know.
> 
> So unless gas is capable of doing this transformation (and it's not as
> of binutils-2.17.50.0.6) "I" is what's needed here.
> 

Just tested it on a K8 machine; AMD behaves the same way.  So "I" is
correct, and changing it to "N" would introduce a bug.

The only way to optimize this is by using __builtin_constant_p() and
adjust the offset appropriately.

	-hpa
