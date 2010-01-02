Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795Ab0ABXHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab0ABXHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374Ab0ABXHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:07:11 -0500
Received: from mail2.shareable.org ([80.68.89.115]:57323 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0ABXHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:07:10 -0500
Date: Sat, 2 Jan 2010 23:07:08 +0000
From: Jamie Lokier <jamie@shareable.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [uClinux-dev] [PATCH] Valid relocation symbol for FLAT format on ARM, v2
Message-ID: <20100102230708.GA32298@shareable.org>
References: <20100101012645.GB16887@Pogoplug> <201001010123.49951.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001010123.49951.vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> when posting updates, you should put the "v2" and such inside of the
> "[patch]" marker like so: [PATCH v2].  git will remove this
> automatically when applying.

Thanks; I didn't know this.

> On Thursday 31 December 2009 20:26:45 Jun Sun wrote:
> >  #define	flat_old_ram_flag(flags)	(flags)
> > -#define	flat_reloc_valid(reloc, size)	((reloc) <= (size))
> > +#define	flat_reloc_valid(reloc, size)	((reloc) <= (size) + 0x1000)
> > +/* [jsun] new gcc 4.x generates ANCHOR symbols in order to reduce the size
> 
> comments go above the thing they're documenting, not below.  the "[jsun]" is 
> also not really useful -- no one who reads this after the fact will have any 
> idea what "[jsun]" means.

I agree with everything Mike said.  Put the comment before the
#define, and lose the "[jsun]".  If someone wants to know who wrote
the comment they can use "git blame" and get your full email address.

Actually I'd go a bit further: I think it's be tidier to put the
comment and #define in their own block, separated by a blank line from
the other #defines.

I don't see how GCC can make the GOT smaller with relocs pointing
_after_ the end of the BSS (middle yes, but after?), but given that it
does, the patch looks good to me.

-- Jamie
