Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087Ab0ATTtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0ATTtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962Ab0ATTtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:49:40 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44130 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab0ATTtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:49:39 -0500
Date: Wed, 20 Jan 2010 13:49:16 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
In-Reply-To: <4B56328E.9080108@zytor.com>
Message-ID: <alpine.DEB.2.00.1001201333430.15175@router.home>
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010, H. Peter Anvin wrote:

> Could you do this in the standard sequencing for unification patches:
> first patch the two pieces of code so they are identical, and then
> mechanically unifying them?  Otherwise it's almost impossible to see
> what has changed.

Hmmm... Okay I better do that on top of your patches then.

> > This is also a good preparatory patch for getting the rwsem XADD stuff
> > to work on x86_64.
>
> Have you tried the tip:x86/rwsem branch (Linus' work with a few
> additions of mine) and had it not work for you?

No I just saw it. Linus first patch increases the 64/32 bit separation by
creating yet another 64 bit specific file. Can we avoid that and have
code that is shared as much as possible between 32 and 64 bit?

Then there is another that does the %z0 trick while we already have the
proper definitions for that in include/asm/asm.h. Seems that you have
switched to using those. Was that done consistently?

Why have a rwsem_count_t when a simple long would do in both cases? Just
make sure that long is consistently used.

__downgrade_write:  Why use the inc trick instead of the add
like in 32 bit? There is not much difference and it results in much
stabler code.

> > x86_64 gains the FRAME/ENDFRAME handling that i386 has (not sure what the
> > point is of having that there).
>
> Presumably it's so you can have frame pointers everywhere.

For a small code segment that does not do any subroutine calls?
