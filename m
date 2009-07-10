Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZGJOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZGJOLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZGJOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:11:15 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33678 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZGJOLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:11:15 -0400
X-IronPort-AV: E=Sophos;i="4.42,378,1243828800"; 
   d="scan'208";a="1364251"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kernel.printk.c - ensure that "console enabled"messages are printed on the console
Date: Fri, 10 Jul 2009 10:13:56 -0400
User-Agent: KMail/1.9.5
CC: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <200907040017.26921.rgetz@blackfin.uclinux.org> <200907091308.37370.rgetz@blackfin.uclinux.org> <20090710102547.GD5499@elte.hu>
In-Reply-To: <20090710102547.GD5499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907101013.56177.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 10 Jul 2009 14:10:32.0121 (UTC) FILETIME=[2FA77290:01CA0168]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 10 Jul 2009 06:25, Ingo Molnar pondered:
> 
> * Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > Today, when a console is registered without CON_PRINTBUFFER, end 
> > users never see the announcement of it being added, and never know 
> > if they missed something, if the console is really at the start or 
> > not, and just leads to general confusion.
> > 
> > This re-orders existing code, to make sure the console is added, 
> > before the "console [%s%d] enabled" is printed out - ensuring that 
> > this message is _always_ seen.
> > 
> > This has the desired/intended side effect of making sure that 
> > "console enabled:" messages are printed on the bootconsole, and 
> > the real console. This does cause the same line is printed twice 
> > if the bootconsole and real console are the same device, but if 
> > they are on different devices, the message is printed to both 
> > consoles.
> > 
> > Signed-off-by : Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > ---
> > 
> >  printk.c |   44 +++++++++++++++++++++++++++++---------------
> >  1 file changed, 29 insertions(+), 15 deletions(-)
> > 
> > patch generated for -tip
> 
> Looks good, applied it to tip:core/printk for v2.6.32, thanks Robin. 
> 
> i fixed a couple of small details in the patch:
> 
>  - re-broke the commit log as it was too wide for nice git log 
>    output

Hmm - I didn't know there was a restriction on this - what is the number?

>  - fixed a stray whitespace warned about by scripts/checkpatch.pl
>  - fixed another stray whitespace found the old fashioned way
>  - fixed the patch title to match the prefix used by your previous 
>    commit as well

Thanks
-Robin
