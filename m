Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYCVX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYCVX2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYCVX2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:28:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:23980 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYCVX2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H2zpWOU6dtaqck5Xqmjj8UOsR1Q2PrMCPl3Dgx2p41eXji0YYYazR5RrKvbZ9TifLOGg/++kgsjA0Fvq5TMX5snFcV/aPe+rP0WHaZIaB4GTZ7Zp/FV66moyT2tp220CyC++rAOinnUJ7/DTX8C+stSAPh9sYAssu+AQamJTor4=
Message-ID: <86802c440803221628p60ebab7co3c4a6c1bef39d709@mail.gmail.com>
Date: Sat, 22 Mar 2008 16:28:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported regressions from 2.6.24)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Thomas Meyer" <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <47E5815B.4080002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de>
	 <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de>
	 <47E557D5.9020604@s5r6.in-berlin.de>
	 <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
	 <47E5815B.4080002@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 2:59 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> Linus Torvalds wrote:
>  >
>  > Ingo/Thomas - should ioremap*() perhaps take "resource_size_t" or a "u64"
>  > for the address (and then "__ioremap()" should probably take a PFN, not a
>  > physical address, and that one can remain just a "unsigned long"?)
>  >
>
>  resource_size_t seems to make sense here.  In the case when we have
>  64-bit resources but no PAE support we should error our when the
>  resource is out of range rather than silently fail.
>
>
>  > Has anybody ever had a working 64-bit BAR on x86? Ivan? Maybe I'm missing
>  > something..
>
>  64-bit BAR, certainly.  64-bit BAR with a value beyond 4 GB I would find
>  questionable at best... I suspect the answer is "no".
>
Opteron system with coprocessor on socket or HTX slot. will use 64bit
BAR above 4g and size is more than 4g too.

YH
