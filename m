Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbXK0U6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbXK0U6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbXK0U6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:58:32 -0500
Received: from ozlabs.org ([203.10.76.45]:36917 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092AbXK0U6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:58:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18252.34032.207280.742887@cargo.ozlabs.ibm.com>
Date: Wed, 28 Nov 2007 07:58:24 +1100
From: Paul Mackerras <paulus@samba.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 11/14] Powerpc: Use generic per cpu
In-Reply-To: <Pine.LNX.4.64.0711271016260.2310@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com>
	<20071127001431.688565525@sgi.com>
	<F81BD9A7-9D76-4C2C-AF80-AAA3F70F061E@kernel.crashing.org>
	<Pine.LNX.4.64.0711271016260.2310@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter writes:
> On Tue, 27 Nov 2007, Kumar Gala wrote:
> 
> > > Index: linux-2.6/include/asm-powerpc/percpu.h
> > > ===================================================================
> > > --- linux-2.6.orig/include/asm-powerpc/percpu.h	2007-11-24
> > > 10:27:31.088350556 -0800
> > > +++ linux-2.6/include/asm-powerpc/percpu.h	2007-11-24 10:29:20.752350757
> > > -0800
> > > @@ -16,25 +16,6 @@
> > > #define __my_cpu_offset() get_paca()->data_offset
> > > #define per_cpu_offset(x) (__per_cpu_offset(x))
> > 
> > This concerns me.  paca doesn't exist on all PPC platforms.
> 
> I wonder why the current code is working then.

Did you try both 32-bit (CONFIG_64BIT=n) and 64-bit (CONFIG_64BIT=y)
configurations?  The paca only exists in 64-bit kernels.

Paul.
