Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbXGWGDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbXGWGDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXGWGDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:03:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbXGWGDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:03:47 -0400
Date: Mon, 23 Jul 2007 02:03:39 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: vdso.so mislinked by buggy linker was Re: Linus 2.6.23-rc1
Message-ID: <20070723060339.GN2063@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707230131.00302.ak@suse.de> <20070722233840.GJ30660@skl-net.de> <200707230156.20276.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707230156.20276.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:56:20AM +0200, Andi Kleen wrote:
> On Monday 23 July 2007 01:38:40 Andre Noll wrote:
> [readded linux-kernel, Linus]
> 
> >   [Nr] Name              Type             Address           Offset
> >        Size              EntSize          Flags  Link  Info  Align
> >   [ 0]                   NULL             0000000000000000  00000000
> >        0000000000000000  0000000000000000           0     0     0
> >   [ 1] .hash             HASH             ffffffffff700120  00000120
> >        00000000000000b4  0000000000000004   A       2     0     8
> >   [ 2] .dynsym           DYNSYM           ffffffffff7001d8  000001d8
> >        0000000000000270  0000000000000018   A       3    12     8
> >   [ 3] .dynstr           STRTAB           ffffffffff700448  00000448
> >        0000000000000059  0000000000000000   A       0     0     1
> >   [ 4] .gnu.version      VERSYM           ffffffffff7004a2  000004a2
> >        0000000000000034  0000000000000002   A       2     0     2
> >   [ 5] .gnu.version_d    VERDEF           ffffffffff7004d8  000004d8
> >        0000000000000038  0000000000000000   A       3     2     8
> >   [ 6] .text             PROGBITS         ffffffffff700c00  00100bab
>                                                               ^^^^^^^^
> >        00000000000002e4  0000000000000000  AX       0     0     64
> 
> It puts .text at 1MB. Your vdso file must be huge? 
> 
> It looks like it ignores the
> -Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
> options passed to it. The AMD64 ABI has a 1MB minimum page size, but
> these options are supposed to disable it.

These options are fairly new, before they were ignored (like all unknown
-z options).  They were added 2006-05-30 to CVS binutils.

I guess the problem is caused by the gap being too big and old binutils.

	Jakub
