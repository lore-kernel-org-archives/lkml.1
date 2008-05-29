Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbYE2NVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbYE2NVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYE2NVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:21:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47374 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbYE2NVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:21:08 -0400
Date: Thu, 29 May 2008 16:21:05 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: David Howells <dhowells@redhat.com>
cc: Christoph Lameter <clameter@sgi.com>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <29611.1212066517@redhat.com>
Message-ID: <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi>
References: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI>
 <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi>
 <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com>
 <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, David Howells wrote:
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

For short term, we should merge my two nommu patches as-is, no?
