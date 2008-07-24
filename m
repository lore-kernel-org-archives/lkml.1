Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbYGXQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbYGXQEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYGXQEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:04:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYGXQEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:04:39 -0400
Date: Thu, 24 Jul 2008 12:03:00 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
Message-ID: <20080724160300.GA7225@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


On Wed, Jul 23, 2008 at 12:25:05PM -0400, Theodore Tso wrote:
> > I also proposed a compromise where systemtap would use the
> > symbol+offset interface, but choose a single convenient symbol as base
> > for all probes in a particular elf file (/section).
> 
> I guess I don't see the value of that over just using the address
> directly.  James' point wasn't just to use the symbol+offset feature
> just for the sake of using it, but rather as a better way of
> specifying how to insert a probe into a kernel.

Right, I understand that this is the theory, but I believe the
difference between symbol+offset vs. _stext+offset
vs. absolute-address is almost entirely aesthetic rather than
functional.


> For example, it may be that by allowing the kernel to have a bit
> more semantic knowledge of where a probe is going, it could more
> easily do various safety-related checks that can't be done if all it
> is given is a raw address.

This is unlikely to be the case.  The kernel can map from addresses to
symbols internally on demand, should such extra safety checks come
into existence.  It can already check for __kprobes marked-ness,
regardless of the API.


> > As a quality-of-implementation matter, systemtap checks at translation
> > time that such probes make sense -- that "ext4_fill_super" even
> > exists.  (That is needed also to expand wildcards.)  The only way it
> > can do that is if it has dwarf or separate textual symbol table data
> > (see above).  Both of those carry addresses as well, so we might as
> > well use them.
> 
> True, though I'll note for modern kernels, with /proc/kallsyms, we
> should hopefully be able to do this (offset=0 probes) without DWARF
> headers. [...]

Yes, that's what I was referring to ("... or separate textual symbol
table").  Note that this table contains addresses too.


> BTW, one of the things which I have wondered is whether DWARF was
> really the right approach after all, given how bloated and
> space-inefficient it seems to be.  [...]

Yeah, it is probably the main source of pain in using systemtap at its
fullest.


> [...]  So there is a big difference between "please do X, Y, and Z
> first and the patch would then be acceptable" versus "for reasons A,
> B and C this patch is totally unacceptable and in fact what you are
> trying to do is pointless".

I am sorry for my part in lowering the tone of the discussion.  We
will work out how to put James' patch in, with backward-compatiblity
extensions.


- FChE
