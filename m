Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbXK1CgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbXK1CgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 21:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbXK1Cfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 21:35:54 -0500
Received: from ozlabs.org ([203.10.76.45]:37863 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759915AbXK1Cfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 21:35:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18252.54275.429917.929763@cargo.ozlabs.ibm.com>
Date: Wed, 28 Nov 2007 13:35:47 +1100
From: Paul Mackerras <paulus@samba.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 11/14] Powerpc: Use generic per cpu
In-Reply-To: <Pine.LNX.4.64.0711271311370.4590@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com>
	<20071127001431.688565525@sgi.com>
	<F81BD9A7-9D76-4C2C-AF80-AAA3F70F061E@kernel.crashing.org>
	<Pine.LNX.4.64.0711271016260.2310@schroedinger.engr.sgi.com>
	<18252.34032.207280.742887@cargo.ozlabs.ibm.com>
	<Pine.LNX.4.64.0711271311370.4590@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter writes:

> On Wed, 28 Nov 2007, Paul Mackerras wrote:
> 
> > Did you try both 32-bit (CONFIG_64BIT=n) and 64-bit (CONFIG_64BIT=y)
> > configurations?  The paca only exists in 64-bit kernels.
> 
> I build both and there is no dependency on 32bit or 64 bit in 
> include/asm-powerpc/percpu.h. Both access the paca (whatever that is).

Look at line 3 of include/asm-powerpc/percpu.h:

#ifdef __powerpc64__

As far as I can see, after applying your series of patches, I end up
with an unbalanced #ifdef in include/asm-powerpc/percpu.h.  I see 3
#ifdef/#ifndef, but only two #endifs.  It needs another #endif after
the #endif /* SMP */ to match the #ifdef __powerpc64__.  With that
change it looks OK, since 32-bit uses asm-generic/percpu.h for both
SMP and UP.

Paul.
