Return-Path: <linux-kernel-owner+w=401wt.eu-S1031094AbXDYP3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031094AbXDYP3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031097AbXDYP3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:29:30 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49364 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031094AbXDYP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:29:29 -0400
Date: Wed, 25 Apr 2007 08:29:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] slub: update cpu after new_slab()
In-Reply-To: <Pine.LNX.4.64.0704251613280.19217@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704250824070.24363@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704251613280.19217@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Hugh Dickins wrote:

> SLUB gave me a NULL pointer dereference in slab_alloc(), in the
> slab_lock(page) of its "Current cpuslab is acceptable" block: cpu
> 1 had been looking at cpu_slab[2], which then went NULL beneath it.
> Since new_slab() may reenable interrupts and sleep (when __GFP_WAIT),
> we may get rescheduled on a different cpu: so need to reevaluate it.

Right. local_irq_save does not switch off preemption as I thought.

Acked-by: Christoph Lameter <clameter@sgi.com>
