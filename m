Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbYGQAia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbYGQAia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYGQAiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:38:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbYGQAiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:38:20 -0400
Date: Wed, 16 Jul 2008 17:38:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [git pull] PCI pull request for 2.6.27
In-Reply-To: <Pine.LNX.4.55.0807170109470.30858@cliff.in.clinika.pl>
Message-ID: <alpine.LFD.1.10.0807161732510.2835@woody.linux-foundation.org>
References: <200807161639.24289.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161647470.2835@woody.linux-foundation.org> <200807161654.55699.jbarnes@virtuousgeek.org> <Pine.LNX.4.55.0807170109470.30858@cliff.in.clinika.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Maciej W. Rozycki wrote:
> 
>  Conveniently "for" is short enough for indentation like this:
> 
> 	for (addr = (u8 *) __va(0xf0000);
> 	     addr < (u8 *) __va(0x100000);
> 	     addr += 16) {
>                 rt = pirq_check_routing_table(addr);

I don't actually like that one very much either.

It's perfectly readable when looking at things closely, but it's not very 
nice when quickly "scanning" code visually. It looks like two separate 
indents.

Btw, that "code scanning" is not necessarily a bad idea. It's actually 
pretty interesting to print code out in a 2-point font (or just open a 
terminal and do "ctrl -" several times to make the code basically 
unreadable). See if the code flow makes sense from 10,000 feet - you can 
pick up overlong functions and various other dubious practices really 
clearly (#ifdef's in code etc).

(IOW, the whole point of the exercise is to _not_ be able to actually read 
the code, but just look at the _shape_ of it).

Btw, that commit also did things like change the coding style to a 
non-kernel coding style by changing

	static int function(xyz..)

to

	static int
	function(xyz..)

just to make lines shorter. Again - introducing bigger problems than it 
actually fixes.

				Linus
