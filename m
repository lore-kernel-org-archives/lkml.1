Return-Path: <linux-kernel-owner+w=401wt.eu-S936525AbXGWVG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936525AbXGWVG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbXGWVGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:06:48 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:44001 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbXGWVGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:06:47 -0400
Date: Mon, 23 Jul 2007 14:06:45 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__
 __volatile__
In-Reply-To: <46A51254.8000508@goop.org>
Message-ID: <Pine.LNX.4.58.0707231405400.5535@shell2.speakeasy.net>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A4D612.9050209@goop.org> <Pine.LNX.4.64.0707232202580.22155@cselinux1.cse.iitk.ac.in>
 <46A4E7E3.8090105@goop.org> <Pi <46A4F360.2000905@goop.org>
 <Pine.LNX.4.58.0707231325050.5535@shell2.speakeasy.net> <46A51254.8000508@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Jeremy Fitzhardinge wrote:
> Trent Piepho wrote:
> > gcc also tries to count the number of instructions, to guess how large in
> > bytes the asm block is, as it could make a difference for near vs short
> > jumps, etc.
> >
>
> How does it do that?  By looking for \n, ';', etc?

Yes:

    Some targets require that GCC track the size of each instruction used in
    order to generate correct code.  Because the final length of an `asm' is
    only known by the assembler, GCC must make an estimate as to how big it
    will be.  The estimate is formed by counting the number of statements in
    the pattern of the `asm' and multiplying that by the length of the longest
    instruction on that processor.  Statements in the `asm' are identified by
    newline characters and whatever statement separator characters are
    supported by the assembler; on most processors this is the ``;''
    character.
