Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbYAaXKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbYAaXKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYAaXJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:09:58 -0500
Received: from relay1.sgi.com ([192.48.171.29]:58042 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751732AbYAaXJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:09:58 -0500
Date: Thu, 31 Jan 2008 15:09:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v5
In-Reply-To: <Pine.LNX.4.64.0801311207540.25477@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0801311508080.23624@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131171806.GN7185@v2.random>
 <Pine.LNX.4.64.0801311207540.25477@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Christoph Lameter wrote:

> > pagefault against the main linux page fault, given we already have all
> > needed serialization out of the PT lock. XPMEM is forced to do that
> 
> pt lock cannot serialize with invalidate_range since it is split. A range 
> requires locking for a series of ptes not only individual ones.

Hmmm.. May be okay after all. I see that you are only doing it on the pte 
level. This means the range callbacks are taking down a max of 512 
entries. So you have a callback for each pmd. A callback for 2M of memory?




