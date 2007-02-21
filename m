Return-Path: <linux-kernel-owner+w=401wt.eu-S1423256AbXBUXVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423256AbXBUXVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423257AbXBUXVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:21:00 -0500
Received: from ozlabs.org ([203.10.76.45]:39471 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423256AbXBUXU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:20:59 -0500
Subject: Re: [patch 05/24] Xen-paravirt_ops: Add pagetable accessors to
	pack and unpack pagetable entries
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: virtualization@lists.osdl.org, Chris Wright <chrisw@sous-sol.org>,
       xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200702212315.12883.ak@suse.de>
References: <20070221205254.169835700@goop.org>
	 <20070221205322.869165491@goop.org>  <200702212315.12883.ak@suse.de>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 10:20:02 +1100
Message-Id: <1172100002.13378.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 23:15 +0100, Andi Kleen wrote:
> On Wednesday 21 February 2007 21:52, Jeremy Fitzhardinge wrote:
> > Add a set of accessors to pack, unpack and modify page table entries
> > (at all levels).  This allows a paravirt implementation to control the
> > contents of pgd/pmd/pte entries.  For example, Xen uses this to
> > convert the (pseudo-)physical address into a machine address when
> > populating a pagetable entry, and converting back to pphys address
> > when an entry is read.
> 
> Do you have some lmbench numbers before/after this change? 
> iirc at least fork and exit do a lot of pte accesses in various forms.
> If it's measurable it might be needed to patch those for the native case.

Yes, __mkpte must be patched to avoid performance embarrassment.

Jeremy, did you want me to do this, or are you happy to?
Rusty.
PS. I really must revise my "paravirt-ops counter" patch which tallies
how much each op is getting called.


