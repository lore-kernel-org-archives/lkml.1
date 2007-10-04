Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbXJDBop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbXJDBop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 21:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXJDBof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 21:44:35 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:53077 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXJDBoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 21:44:34 -0400
X-Greylist: delayed 1897 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 21:44:34 EDT
Date: Thu, 04 Oct 2007 10:11:53 +0900 (JST)
Message-Id: <20071004.101153.28792915.hyoshiok@miraclelinux.com>
To: torvalds@linux-foundation.org
Cc: penberg@cs.helsinki.fi, neil@romig.demon.co.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hyoshiok@miraclelinux.com
Subject: Re: File corruption when using kernels 2.6.18+
From: Hiro Yoshioka <hyoshiok@miraclelinux.com>
In-Reply-To: <alpine.LFD.0.999.0710031247030.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710031209450.3579@woody.linux-foundation.org>
	<84144f020710031235r29986ceaj3260e8271eee6ddb@mail.gmail.com>
	<alpine.LFD.0.999.0710031247030.3579@woody.linux-foundation.org>
X-Mailer: Mew version 3.3 on XEmacs 21.4.13 (Rational FORTRAN)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.10.3.175225
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

From: Linus Torvalds <torvalds@linux-foundation.org>
> On Wed, 3 Oct 2007, Pekka Enberg wrote:
> > 
> > On 10/3/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > I would bet that the reason the intel-optimized memcpy triggers this is
> > > that the non-temporal stores just means that you go out directly on the
> > > bus, and it probably just shows a weakness in the chipset or bus that
> > > doesn't show with the normal cacheline accesses.
> > 
> > But that should show up with memtest too, no?
> 
> Not unless memtest uses non-temporal stores with the same (or similar) 
> access patterns.
> 
> The thing is, the CPU cache hides a *lot* of activity from the chipset, 
> and changes the access patterns radically. 
> 
> With normal cached accesses, you'd normally see just the "fill cacheline" 
> and "write out cacheline" pattern. With movnt, you'd see non-cacheline 
> accesses to memory. If the chipset was tested under mostly normal loads, 
> the movnt cases have been getting a lot less coverage.

I'm not so sure whether it is chipset's bug or not.

The movnt does have the WC (write combining) semantics and
bypass the hardware cache to store the data.

http://www.intel.com/products/processor/manuals/index.htm

Intel 64 and IA-32 Architectures Software Developer's Manual
Volume 1: Basic Architecture

Intel 64 and IA-32 Architectures Software Developer's Manual
Volume 3A: System Programming Guide

Thanks in advance,
  Hiro
