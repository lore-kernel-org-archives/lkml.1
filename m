Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYA3DH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYA3DH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYA3DHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:07:21 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33092 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYA3DHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:07:20 -0500
Date: Tue, 29 Jan 2008 19:24:32 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/2] x86_64: make early_node_mem return align address
In-reply-to: <200801300355.46342.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801291924.33406.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801290053.45776.yinghai.lu@sun.com>
 <200801290941.54145.yinghai.lu@sun.com> <200801300355.46342.ak@suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 06:55:45 pm Andi Kleen wrote:
> On Tuesday 29 January 2008 18:41, Yinghai Lu wrote:
> > On Tuesday 29 January 2008 01:33:29 am Andi Kleen wrote:
> > > On Tuesday 29 January 2008 10:05, Yinghai Lu wrote:
> > > > [PATCH 2/2] x86_64: make early_node_mem return align address
> > > >
> > > > boot oops when system get 64g or 128g installed
> > >
> > > Probably it should just use reserve_early(). Does this patch work?
> > >
> > > The alignment change is needed at some point too, but only to
> > > relax the alignment to not force all early allocations to be page
> > > padded.
> >
> > No, my patch doesn't force all early allocations to be page padded.
> > for find_e820_mem, i just change PAGE_ALIGN to be aligned align
> > parameter....
> 
> They are already all PAGE_ALIGN()ed (which is too strict, but needs
> some care to fix properly), but your patch uses it the wrong way.
> The PAGE_ALIGNment was added some time ago to avoid such over
> lapping, but it should not actually be needed for that anymore.
> 
> >
> > only make early_node_mem have aligned data. because it seems it like
> > to...and assume that.
> 
> Using alignment doesn't seem the correct way to avoid overlapping.
> 
> If there is still overlap then some reservation needs to be extended.
> 
> > I think your patch will get early panic about overlap between bss and
> > bootmem... like the 256g machine, bss is overlapped with early page
> > table...
> 
> Well did you test it? 
> 
> bss should have been reserved by this line in head64.c 
> 
>         reserve_early(__pa_symbol(&_text), __pa_symbol(&_end));
> 
> (in git-x86). In earlier kernels it was checked for explicitely by the e820 
> allocator.

no early panic. but the bss end still get corrupted.

because bootmap_start is used as <<PAGE_SHIFT, and it is overlapped with bss tail page.

YH
