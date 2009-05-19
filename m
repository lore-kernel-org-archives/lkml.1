Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZESOl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZESOl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZESOlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:41:19 -0400
Received: from ozlabs.org ([203.10.76.45]:53635 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZESOlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:41:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler fixes
Date: Tue, 19 May 2009 21:57:00 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Yinghai Lu <yinghai@kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20090518142707.GA24142@elte.hu> <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905192157.02079.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 07:36:26 am Linus Torvalds wrote:
> > One of the biggest user of bootmem is the mem_map[] hierarchies and
> > the page allocator bitmaps. Not sure we can get rid of bootmem there
> > - those areas are really large, physical memory is often fragmented
> > and we need a good NUMA sense for them as well.
>
> I think that's the _valid_ kind of use of a bootmem allocator.
>
> But for something like the scheduler data structures? Not so much.

Yeah, and it feels dirty to use slab_is_available() to figure if the code 
should kmalloc or alloc_bootmem.  

Ideally kmalloc/kfree would "always work".  But at least we could get closer.

Thanks,
Rusty.
