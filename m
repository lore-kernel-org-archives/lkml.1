Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZESRwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZESRwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZESRwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:52:38 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:26365 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753289AbZESRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:52:37 -0400
Message-ID: <950448.6018.qm@web32607.mail.mud.yahoo.com>
X-YMail-OSG: aIETSJ8VM1lFer0qPbzf1qC8LorPmPkDFB6_5uMt_dPzW8l.lDUIl2N7GiQ.xFmMy.34_QnUHnfRTHJvfmtICtzvezFNm5MXrGlQ4vN8Yc.WMynavKlKyfsmgCWab6qI.varEpoXMvhXEu2l2JNA53pGX0_2xDGHu.jJ4RGY2RR89M.J8ajtZHIWtqeDExMB9nhMBYvYixNaC6uGrzftP_e48w3BDroYgLFdBXelpNDbRQWr3oO3ICofSTp7xKh7geAIUepwwmp_1DXh2cyz.xWanGrcuIPvGTWL0UYg7PJWUZI-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <688406.16641.qm@web32603.mail.mud.yahoo.com> <20090518203420.GF2658@calx> <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain> <231530.33013.qm@web32601.mail.mud.yahoo.com> <alpine.LFD.2.01.0905190745230.3301@localhost.localdomain>
Date: Tue, 19 May 2009 10:52:38 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0905190745230.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Linus Torvalds <torvalds@linux-foundation.org>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Matt Mackall <mpm@selenic.com>; Ingo Molnar <mingo@elte.hu>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Sent: Tuesday, May 19, 2009 5:09:40 PM
> Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
> 
> 
> 
> On Tue, 19 May 2009, Martin Knoblauch wrote:
> > 
> >  With your patch, the problem still remains. Line 1685 is the end of the 
> patched routine now.
> 
> Ok, so can you do two other simple tests:
> 
> - just remove the  "+ (long)&ret" entirely.
> 
>    Now, usually gcc doesn't have issues with non-asm things, but that's an 
>    odd way of getting the current stack address by lookin gat the address 
>    of a variable that hasn't even been used, so maybe it triggers some 
>    untested codepath in gcc (and thus the bug).
> 

 Removing above fixes the ICE. It does so in both the original and the patched version. 

 Removing get_cycles() has no effect wrt. the ICE.

Cheers
Martin

