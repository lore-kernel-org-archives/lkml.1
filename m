Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYCaS7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYCaS7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYCaS7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:59:03 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33112 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754126AbYCaS7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:59:02 -0400
Date: Mon, 31 Mar 2008 11:56:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <84144f020803291652l13d3de82o424e126655b86119@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803311148090.6510@schroedinger.engr.sgi.com>
References: <200803272353.51901.rjw@sisk.pl> 
 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com> 
 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0803281128480.17805@schroedinger.engr.sgi.com> 
 <alpine.LFD.1.00.0803281214580.14670@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0803291330190.26394@schroedinger.engr.sgi.com> 
 <alpine.LFD.1.00.0803291422160.14670@woody.linux-foundation.org>
 <84144f020803291652l13d3de82o424e126655b86119@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Pekka Enberg wrote:

> Christoph, I think you're overlooking the same thing I was until Linus
> straightened me out. We're calling kmalloc_large() from __slab_alloc()
> for the fall-back case which causes a bug fixed by Linus' revert.

Yes, that means that __GFP_ZERO can be passed to the page allocator there. 
Same thing as happens when kmalloc() calls kmalloc_large() (as you pointed 
out before). The harm is zeroing an allocated object twice in rare cases 
that trigger the fallback path and that is avoided by Linus' patch.

For the fix to get rid of the backtraces that started this discussion see
commit 9c312058b2e530722c7bd30c1b6f26eea35dc5fe

