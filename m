Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbZGCTNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbZGCTNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZGCTNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:13:16 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:42150 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbZGCTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:13:15 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 14:13:15 -0500
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <200907031314.36243.lkml@morethan.org> <200907031338.24778.lkml@morethan.org> <4A4E5738.6080407@goop.org>
In-Reply-To: <4A4E5738.6080407@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031413.17556.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, Jeremy Fitzhardinge wrote:
> On 07/03/09 11:38, Michael S. Zick wrote:
> > I make no claims for it at the moment - too early in the test process.
> > Just the general observation that it takes 0.5M to describe 0.5G of ram.
> >   
> Only if you're using 4k pages.  With large pages, 1 pte can map 2M, so
> 256 entries can map 512M, so you only need 1/2 a page of pagetable
> (assuming PAE; if not a single entry can map 4M).
> 

Ah, but you can't assume that - look at your VIA-C7M tech sheet - NO PAE.

Mike

> > Also, 
> > the observation that (1<<32) drops the bit off the left end of a 32-bit value.
> > You can see the result in the portion of the post you snipped out.  ;)
> >   
> 
> Those computations aren't done as 32-bit.
>

Try ending the filename in ".S" and passing it to gcc, 
like the build system does.

And while your at it, thank A.K. for snipping off the before/after dmesg.

Mike
> 
> $ as << EOF
> .data
> .byte (1 << 100) >> 100
> EOF
> $ objdump -D a.out
> 
> a.out:     file format elf64-x86-64
> 
> Disassembly of section .data:
> 
> 0000000000000000 <.data>:
>    0:    01                       .byte 0x1
> 
> 
>     J
> 
> 


