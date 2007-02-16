Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbXBPGid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbXBPGid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932968AbXBPGid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:38:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbXBPGic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:38:32 -0500
Date: Thu, 15 Feb 2007 22:37:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 11/21] Xen-paravirt: Add apply_to_page_range() which
 applies a function to a pte range.
Message-Id: <20070215223727.6819f962.akpm@linux-foundation.org>
In-Reply-To: <20070216022531.344125142@goop.org>
References: <20070216022449.739760547@goop.org>
	<20070216022531.344125142@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 18:25:00 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Add a new mm function apply_to_page_range() which applies a given
> function to every pte in a given virtual address range in a given mm
> structure. This is a generic alternative to cut-and-pasting the Linux
> idiomatic pagetable walking code in every place that a sequence of
> PTEs must be accessed.
> 
> Although this interface is intended to be useful in a wide range of
> situations, it is currently used specifically by several Xen
> subsystems, for example: to ensure that pagetables have been allocated
> for a virtual address range, and to construct batched special
> pagetable update requests to map I/O memory (in ioremap()).

There was some discussion about this sort of thing last week.  The
consensus was that it's better to run the callback against a whole pmd's
worth of ptes, mainly to amortise the callback's cost (a lot).

It was implemented in
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/broken-out/smaps-extract-pmd-walker-from-smaps-code.patch
