Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbYIHN02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbYIHN02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYIHN0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:26:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:33563 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYIHN0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:26:14 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Mon, 8 Sep 2008 09:25:59 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com>
In-Reply-To: <48C4A46B.90705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809080925.59732.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 00:04, H. Peter Anvin wrote:
> David Sanders wrote:
> > I checked the distribution I'm using (debian) and the kernel shipped with
> > it does not have  CONFIG_X86_GENERIC set.  This means _when_ they ship a
> > 2.6.27 kernel it won't work with Virtual PC so I won't be able to even
> > install it.
>
> Then please file a bug report with Debian.
Well, OK I could do that.  But I can't bug every distribution in existence for 
the same thing.
>
> > However, with Linus's patch I am guaranteed to work for all kernels built
> > for X86_32 and even for X86_64 because in that case the virtual
> > environment will support the multibyte NOPs.  I need Linus's fix in order
> > to support the Linux-using virtual pc community.  I don't have the
> > resources to lobby each individual distribution about their kernel
> > config.  I want it to just work.
>
> Under that logic we shouldn't even have CPU configurables, since you
> want it to "just work" whatever crap you're running on.  That is EXACTLY
> what CONFIG_X86_GENERIC means, and the fact that any particular
> distribution is broken with respect to not enabling it is a bug in that
> distribution, and not grounds for breaking the upstream kernel.
>
> 	-hpa
I don't see that Linus's patch breaks the upstream kernel.  Just the opposite, 
you go and determine in alternative.c that the processor doesn't support NOPL 
and then go ahead and use it anyway in nops.h.  That makes no sense to me.

Could we use the result of find_nop_table() instead of nops.h?

David
