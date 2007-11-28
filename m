Return-Path: <linux-kernel-owner+w=401wt.eu-S1758355AbXK1SzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355AbXK1SzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbXK1Sys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:54:48 -0500
Received: from relay1.sgi.com ([192.48.171.29]:52029 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757875AbXK1Syq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:54:46 -0500
Date: Wed, 28 Nov 2007 10:54:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Kumar Gala <galak@kernel.crashing.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 11/14] Powerpc: Use generic per cpu
In-Reply-To: <18252.54275.429917.929763@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0711281051540.11968@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <20071127001431.688565525@sgi.com>
 <F81BD9A7-9D76-4C2C-AF80-AAA3F70F061E@kernel.crashing.org>
 <Pine.LNX.4.64.0711271016260.2310@schroedinger.engr.sgi.com>
 <18252.34032.207280.742887@cargo.ozlabs.ibm.com>
 <Pine.LNX.4.64.0711271311370.4590@schroedinger.engr.sgi.com>
 <18252.54275.429917.929763@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Paul Mackerras wrote:

> Christoph Lameter writes:
> 
> > On Wed, 28 Nov 2007, Paul Mackerras wrote:
> > 
> > > Did you try both 32-bit (CONFIG_64BIT=n) and 64-bit (CONFIG_64BIT=y)
> > > configurations?  The paca only exists in 64-bit kernels.
> > 
> > I build both and there is no dependency on 32bit or 64 bit in 
> > include/asm-powerpc/percpu.h. Both access the paca (whatever that is).
> 
> Look at line 3 of include/asm-powerpc/percpu.h:
> 
> #ifdef __powerpc64__
> 
> As far as I can see, after applying your series of patches, I end up
> with an unbalanced #ifdef in include/asm-powerpc/percpu.h.  I see 3
> #ifdef/#ifndef, but only two #endifs.  It needs another #endif after
> the #endif /* SMP */ to match the #ifdef __powerpc64__.  With that
> change it looks OK, since 32-bit uses asm-generic/percpu.h for both
> SMP and UP.

Ahhh.. Ok. Fixed.

Do you know where to get a ppc64 crosscompiler? I 
tried to build gcc for ppc64 but the build failed on x86_64.
