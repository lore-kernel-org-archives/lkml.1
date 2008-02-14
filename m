Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbYBNVr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbYBNVr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYBNVrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:47:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760709AbYBNVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:47:43 -0500
Date: Thu, 14 Feb 2008 13:46:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: adrian.bunk@movial.fi, mingo@elte.hu, linux-kernel@vger.kernel.org,
       riku.voipio@movial.fi, mikpe@it.uu.se, buytenh@wantstofly.org,
       rusty@rustcorp.com.au, stable@kernel.org
Subject: Re: futex local DoS on most architectures
Message-Id: <20080214134642.600282f1.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de>
References: <20080211130700.GF27537@movial.fi>
	<alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 14:59:34 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 11 Feb 2008, Adrian Bunk wrote:
> 
> > The issue described in [1] is still present and unfixed (and even the 
> > fix there wasn't complete since it didn't cover SMP).
> 
> Damn, this slipped through my attention completely. Hotfix (which can
> be easily backported) below.
>  
> > Thanks to Riku Voipio for noting that it is still unfixed.
> > 
> > cu
> > Adrian
> > 
> > [1] http://lkml.org/lkml/2007/8/1/474
> 
> -------->
> 
> Subject: futex: disable PI/robust on archs w/o valid implementation
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> We have to disable the complete PI/robust functionality for those
> archs, which do not implement futex_atomic_cmpxchg_inatomic(). The
> code in question relies on a valid implementation and does not expect
> -ENOSYS, which is returned by the stub implementation in
> asm-generic/futex.h
> 
> Pointed out by: Mikael Pettersson, Riku Voipio and Adrian Bunk
> 
> This patch is intended for easy backporting and needs to be cleaned up
> further for current mainline.

So...

I queued up this version with a cc to stable under the assumption that this
is the patch which should be applied to 2.6.x.y, but this version is not
the one which will go into 2.6.25.

Correct?

If so: messy.  The stable guys might want to wait until they see the real
2.6.25 patch and perhaps prefer to backport that version.


