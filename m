Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbXGVEVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbXGVEVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 00:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbXGVEVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 00:21:09 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:4238 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbXGVEVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 00:21:07 -0400
Date: Sun, 22 Jul 2007 07:20:57 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
Message-ID: <20070722042057.GJ1193@rhun.ibm.com>
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070721181137.GH4152@rhun.haifa.ibm.com> <46A263FA.70501@zytor.com> <20070721201634.GF1193@rhun.ibm.com> <46A26A2E.7070305@zytor.com> <20070721204458.GG1193@rhun.ibm.com> <46A28425.2010202@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A28425.2010202@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 03:09:41PM -0700, H. Peter Anvin wrote:
> Muli Ben-Yehuda wrote:
> > 
> > Ok, let's try again:
> > 
> > You're changing this (pageattr.c)
> > 
> >                 asm volatile("clflush (%0)" :: "r" (adr + i));
> > 
> > into this:
> > 
> > 		asm volatile("clflush %0" : "+m" (*(char __force*)(adr + i)));
> > 
> > The original one calls clflush with (adr + i), the new one with (*(adr
> > + i)). Are these calls equivalent?
> 
> Yes, they are.  The parentheses which are part of the old assembly
> string has the same effect as the asterisk operator in C.

Ah, I see. Thanks for the explanation!

Cheers,
Muli
