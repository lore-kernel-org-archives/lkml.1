Return-Path: <linux-kernel-owner+w=401wt.eu-S1031127AbXDYPvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031127AbXDYPvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031135AbXDYPug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:50:36 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55370 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031127AbXDYPuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:50:06 -0400
X-AuditID: d80ac287-adacabb00000590d-36-462f78ae0921 
Date: Wed, 25 Apr 2007 16:49:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] slub: update cpu after new_slab()
In-Reply-To: <Pine.LNX.4.64.0704250824070.24363@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0704251642450.22530@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704251613280.19217@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704250824070.24363@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 25 Apr 2007 15:49:48.0238 (UTC) FILETIME=[5A6A86E0:01C78751]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Christoph Lameter wrote:
> On Wed, 25 Apr 2007, Hugh Dickins wrote:
> 
> > SLUB gave me a NULL pointer dereference in slab_alloc(), in the
> > slab_lock(page) of its "Current cpuslab is acceptable" block: cpu
> > 1 had been looking at cpu_slab[2], which then went NULL beneath it.
> > Since new_slab() may reenable interrupts and sleep (when __GFP_WAIT),
> > we may get rescheduled on a different cpu: so need to reevaluate it.
> 
> Right. local_irq_save does not switch off preemption as I thought.

Strange comment.  Preemption is not possible while IRQs are disabled,
but new_slab() rightly reenables them within itself in the __GFP_WAIT
case, since it's going off to do a page allocation and may need to wait.

(And actually, this kernel was a CONFIG_PREEMPT_NONE=y one.)

> 
> Acked-by: Christoph Lameter <clameter@sgi.com>

Thanks,
Hugh
