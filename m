Return-Path: <linux-kernel-owner+w=401wt.eu-S2992813AbXDYP77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992813AbXDYP77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992792AbXDYP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:59:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45633 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161779AbXDYP6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:58:54 -0400
Date: Wed, 25 Apr 2007 08:58:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] slub: update cpu after new_slab()
In-Reply-To: <Pine.LNX.4.64.0704251642450.22530@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704250857170.24530@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704251613280.19217@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704250824070.24363@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704251642450.22530@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Hugh Dickins wrote:

> > Right. local_irq_save does not switch off preemption as I thought.
> 
> Strange comment.  Preemption is not possible while IRQs are disabled,
> but new_slab() rightly reenables them within itself in the __GFP_WAIT
> case, since it's going off to do a page allocation and may need to wait.

Yes I expected local_irq_save to increase the preempt count and then 
local_irq_enable to simply enable interrupts without affecting the preempt 
count. Thus the process should stay on the same processor.

Never thought it would be possible to move to a different processor in mid 
flight.
