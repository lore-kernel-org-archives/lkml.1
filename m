Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZESTAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZESTAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 15:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZESTAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 15:00:03 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:36836 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753337AbZESTAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 15:00:02 -0400
Message-ID: <431112.45036.qm@web32602.mail.mud.yahoo.com>
X-YMail-OSG: KJgXO5kVM1mqGUaS9SUE32n5KnIJe.EopDI2HZQprzpTiJDOgAVm4jIMrImKLVCzdzCcjVMBPI78XAc4uhU7qLxm7gWvT7868.1umFmm18DAGxuAvylTAiwgSFz3LE7IeY7tnOQtqjygb_HuPVTta0mrVFU9WC_8H7M.e5RbBugPcwwJ.Vaa3nchg6YK9hG7csN2_9t.9Ft9ST.FtDIIBNIw3w0l6CL.oaFb.4GfBEYHtqDqZZ_vfM1M
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <688406.16641.qm@web32603.mail.mud.yahoo.com> <20090518203420.GF2658@calx> <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain> <231530.33013.qm@web32601.mail.mud.yahoo.com> <alpine.LFD.2.01.0905190745230.3301@localhost.localdomain> <950448.6018.qm@web32607.mail.mud.yahoo.com> <alpine.LFD.2.01.0905191055410.3301@localhost.localdomain> <alpine.LFD.2.01.0905191122320.3301@localhost.localdomain>
Date: Tue, 19 May 2009 12:00:00 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0905191122320.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Linus Torvalds <torvalds@linux-foundation.org>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Matt Mackall <mpm@selenic.com>; Ingo Molnar <mingo@elte.hu>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Sent: Tuesday, May 19, 2009 8:24:48 PM
> Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
> 
> 
> 
> On Tue, 19 May 2009, Linus Torvalds wrote:
> > 
> > I guess getting rid of 'jiffies' is also worth it. Even at its very worst, 
> > 'get_cycles()' should return jiffy-level information, so adding in jiffies 
> > doesn't add anything to it.
> 
> I take that back. If there isno TSC at all, "get_cycles()" might just be 
> returning zero. So the jiffies fallback is probably better than nothing.
> 
> So I'll just remove the (long)&ret part. And you already said that that 
> fixed it both with my previous patch and without, so I guess it's already 
> tested.
> 
>         Linus

 correct. The original code with  (long)&ret removed yields:

        hash[0] += current->pid + jiffies + get_cycles();

and compiles OK.

Tested-by: Martin Knoblauch <spamtrap@knobisoft.de>

Cheers
Martin
