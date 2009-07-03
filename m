Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbZGCUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbZGCUDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZGCUDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:03:11 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:42063 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbZGCUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:03:10 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 15:03:09 -0500
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <200907031314.36243.lkml@morethan.org> <200907031413.17556.lkml@morethan.org> <4A4E5C66.1090206@goop.org>
In-Reply-To: <4A4E5C66.1090206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031503.11551.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, Jeremy Fitzhardinge wrote:
> On 07/03/09 12:13, Michael S. Zick wrote:
> > On Fri July 3 2009, Jeremy Fitzhardinge wrote:
> >   
> >> On 07/03/09 11:38, Michael S. Zick wrote:
> >>     
> >>> I make no claims for it at the moment - too early in the test process.
> >>> Just the general observation that it takes 0.5M to describe 0.5G of ram.
> >>>   
> >>>       
> >> Only if you're using 4k pages.  With large pages, 1 pte can map 2M, so
> >> 256 entries can map 512M, so you only need 1/2 a page of pagetable
> >> (assuming PAE; if not a single entry can map 4M).
> >>
> >>     
> >
> > Ah, but you can't assume that - look at your VIA-C7M tech sheet - NO PAE.
> >   
> 
> According to
> http://www.via.com.tw/en/products/processors/c7-m/secure_by_design.jsp,
> it supports NX, which means it must support PAE.
>

Interesting - this *&^&^% technical datasheet contradicts itself (again).
It can't see to decide if it does or it doesn't - -

I guess I will have to ask the silicon - with my own code - I have a
hardware diagnostic here that claims it doesn't (but it is closed source...)
so I don't know if it is testing or guessing.

 
> But even without PAE, it can still support PSE (large pages).
> 
> > Try ending the filename in ".S" and passing it to gcc, 
> > like the build system does.
> >   
> 
> It doesn't make any difference.  After going through cpp the expression is:
> 
>     # 62 "/home/jeremy/git/linux/arch/x86/kernel/head_32.S"
>     MAPPING_BEYOND_END = (((((1<<32) - 0xC0000000) >> 12) / 512) + 4) << 12
>       
> 
> which will be evaluated by the assembler.   The C preprocessor doesn't
> evaluate expressions in the source; it only ever does substitutions and
> leaves the results for the compiler/assembler to evaluate.  (It evals
> expressions on cpp # lines, of course, but that's not relevant here.)
> 

That is probably what I had in my mind - the "# line" case, sorry, my bad.

Mike
>     J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


