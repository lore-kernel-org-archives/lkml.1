Return-Path: <linux-kernel-owner+w=401wt.eu-S1750971AbZESPLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbZESPLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZESPLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:11:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbZESPLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:11:34 -0400
Date: Tue, 19 May 2009 08:09:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Martin Knoblauch <spamtrap@knobisoft.de>
cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from
 drivers/char/random.c
In-Reply-To: <231530.33013.qm@web32601.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.2.01.0905190745230.3301@localhost.localdomain>
References: <688406.16641.qm@web32603.mail.mud.yahoo.com> <20090518203420.GF2658@calx> <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain> <231530.33013.qm@web32601.mail.mud.yahoo.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 May 2009, Martin Knoblauch wrote:
> 
>  With your patch, the problem still remains. Line 1685 is the end of the patched routine now.

Ok, so can you do two other simple tests:

 - just remove the  "+ (long)&ret" entirely.

   Now, usually gcc doesn't have issues with non-asm things, but that's an 
   odd way of getting the current stack address by lookin gat the address 
   of a variable that hasn't even been used, so maybe it triggers some 
   untested codepath in gcc (and thus the bug).

 - if that doesn't make a difference, then remove the "get_cycles() +" 
   part instead.

   The fact that "arch/x86/include/asm/tsc.h:23" is mentioned in the insn 
   dump does make it look like get_cycles(), but on the other hand I'd 
   have actually expected it to be "arch/x86/include/asm/msr.h:112", 
   because that is the location of the actual asm statement. 

Just to see which part of it gcc has issues with.

		Linus
