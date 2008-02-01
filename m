Return-Path: <linux-kernel-owner+w=401wt.eu-S1764424AbYBAC0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764424AbYBAC0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYBAC0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:26:37 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46457 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752434AbYBAC0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:26:37 -0500
Date: Thu, 31 Jan 2008 18:26:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v5
In-Reply-To: <20080201022321.GZ26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801311824360.25839@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131171806.GN7185@v2.random>
 <Pine.LNX.4.64.0801311207540.25477@schroedinger.engr.sgi.com>
 <20080131232842.GQ7185@v2.random> <Pine.LNX.4.64.0801311733140.24297@schroedinger.engr.sgi.com>
 <20080201022321.GZ26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Robin Holt wrote:

> > Mutex locking? Could you be more specific?
> 
> I think he is talking about the external locking that xpmem will need
> to do to ensure we are not able to refault pages inside of regions that
> are undergoing recall/page table clearing.  At least that has been my
> understanding to this point.

Right this has to be something like rw spinlock. Its needed for both 
GRU/XPmem. Not sure about KVM.

Take the read lock for invalidate operations. These can occur 
concurrently. (Or a simpler implementation for the GRU may just use a 
spinlock).

The write lock must be held for populate operations.

Lock can be refined as needed by the notifier driver. F.e. locking could 
be restricted to certain ranges.

