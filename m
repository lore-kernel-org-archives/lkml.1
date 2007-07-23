Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbXGWGH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbXGWGH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXGWGHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:07:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbXGWGHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:07:51 -0400
Date: Mon, 23 Jul 2007 02:07:46 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Andre Noll <maan@systemlinux.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070723060746.GO2063@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707230022.11831.ak@suse.de> <20070722232338.GI30660@skl-net.de> <200707230131.00302.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707230131.00302.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:31:00AM +0200, Andi Kleen wrote:
> On Monday 23 July 2007 01:23:38 Andre Noll wrote:
> > On 00:22, Andi Kleen wrote:
> > > > /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
> > > 
> > > Does this patch fix it?
> > 
> > Nope, with 0x600 I still get the same error. But it helped to further
> > increase VDSO_TEXT_OFFSET to 0xc00. I tried 0x700, 0x800,... and 0xc00
> > is the smallest value in this series that makes the error go away, i.e.
> > the patch below works for me.
> 
> Can you send (privately) readelf -a output from your vdso.so ? 
> Your linker must be doing something weird.
> 
> 0xc00 is quite wasteful.

I think Roland's --build-id doesn't create very big section, the likely
culprit would be a hacked up ld that e.g. defaults to --hash-style=both.
Can you retry with --hash-style=sysv?  vdso really has to include the
traditional .hash section, otherwise it wouldn't be compatible with
old glibcs, and an additional .gnu.hash might be an overkill for it
- doesn't the vdso define only very few symbols?

	Jakub
