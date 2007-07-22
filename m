Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXGVX4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXGVX4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759818AbXGVX4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:56:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:41119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbXGVX4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:56:24 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andre Noll <maan@systemlinux.org>
Subject: vdso.so mislinked by buggy linker was Re: Linus 2.6.23-rc1
Date: Mon, 23 Jul 2007 01:56:20 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707230131.00302.ak@suse.de> <20070722233840.GJ30660@skl-net.de>
In-Reply-To: <20070722233840.GJ30660@skl-net.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230156.20276.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 01:38:40 Andre Noll wrote:
[readded linux-kernel, Linus]

>   [Nr] Name              Type             Address           Offset
>        Size              EntSize          Flags  Link  Info  Align
>   [ 0]                   NULL             0000000000000000  00000000
>        0000000000000000  0000000000000000           0     0     0
>   [ 1] .hash             HASH             ffffffffff700120  00000120
>        00000000000000b4  0000000000000004   A       2     0     8
>   [ 2] .dynsym           DYNSYM           ffffffffff7001d8  000001d8
>        0000000000000270  0000000000000018   A       3    12     8
>   [ 3] .dynstr           STRTAB           ffffffffff700448  00000448
>        0000000000000059  0000000000000000   A       0     0     1
>   [ 4] .gnu.version      VERSYM           ffffffffff7004a2  000004a2
>        0000000000000034  0000000000000002   A       2     0     2
>   [ 5] .gnu.version_d    VERDEF           ffffffffff7004d8  000004d8
>        0000000000000038  0000000000000000   A       3     2     8
>   [ 6] .text             PROGBITS         ffffffffff700c00  00100bab
                                                              ^^^^^^^^
>        00000000000002e4  0000000000000000  AX       0     0     64

It puts .text at 1MB. Your vdso file must be huge? 

It looks like it ignores the
-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
options passed to it. The AMD64 ABI has a 1MB minimum page size, but
these options are supposed to disable it.

Not sure how to work around this, but having an 1+MB vdso would be incredibly
wasteful. What version is it? Perhaps we just drop support for this. I can't
think of a workaround currently.

-Andi
