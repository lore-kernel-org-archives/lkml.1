Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYJVOkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYJVOkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYJVOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:40:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33794 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752150AbYJVOkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:40:23 -0400
Date: Wed, 22 Oct 2008 09:40:22 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86: Add UV memory protection bios call
Message-ID: <20081022144021.GB201004@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20081021200112.GD32545@sgi.com> <20081022062235.GD651@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022062235.GD651@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 08:22:35AM +0200, Ingo Molnar wrote:
> 
> * Russ Anderson <rja@sgi.com> wrote:
> 
> > Add UV bios call to change memory protections.
> > 
> > Signed-off-by: Russ Anderson <rja@sgi.com>
> > 
> > ---
> >  arch/x86/kernel/bios_uv.c |    8 ++++++++
> >  include/asm-x86/uv/bios.h |   10 +++++++++-
> >  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> > -	UV_BIOS_WATCHLIST_FREE
> > +	UV_BIOS_WATCHLIST_FREE,
> > +	UV_BIOS_MEMPROTECT
> 
> > +enum uv_memprotect {
> > +	UV_MEMPROT_RESTRICT_ACCESS,
> > +	UV_MEMPROT_ALLOW_AMO,
> > +	UV_MEMPROT_ALLOW_RW
> 
> hm, what does this do? Does it twiddle the southbridge to protect given 
> physical RAM rages from the CPU altogether?

The SGI UV hardware has memory protection to control what types of memory
references are allowed to specific physical RAM ranges.  This bios call
is used to change the protection settings.

This is used by the xp driver (drivers/misc/sgi-xp/xp_sn2.c).
Dean Nelson submitted a patch yesterday that uses this bios call.

http://marc.info/?l=linux-kernel&m=122462425819289&w=2

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
