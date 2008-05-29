Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYE2PBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYE2PBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYE2PBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:01:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49402 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753895AbYE2PBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:01:00 -0400
Date: Thu, 29 May 2008 08:00:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Howells <dhowells@redhat.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <29611.1212066517@redhat.com>
Message-ID: <Pine.LNX.4.64.0805290759580.5111@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI>
 <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi>
 <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com>
 <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, David Howells wrote:

> > Could the nommu people either tell us what this is all about? Or junk the 
> > code. This looks very wrong.
> 
> ELF-FDPIC is currently using kobjsize() so that it can expand the heap/stack
> segment to fill up the entirety of its allocation.  It's probably worth
> dropping that, though.
> 
> NOMMU mmap() is using kobjsize()/ksize() to keep track of the number of bytes
> allocated and the amount of dead space.  We can probably ditch that too.
> 
> However, fs/proc/task_nommu.c uses kobjsize() quite a bit to determine how
> much metadata space a process is carrying around.  We could just use sizeof(),
> I suppose, and not bother calculating the slack.

The nagging question here is: Why is page->private used in kobjsize()?  A 
special heap/stack setup?


