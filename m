Return-Path: <linux-kernel-owner+w=401wt.eu-S965610AbXCPQr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610AbXCPQr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965624AbXCPQr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:47:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35075 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965610AbXCPQrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:47:25 -0400
Date: Fri, 16 Mar 2007 09:47:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 15/26] Xen-paravirt_ops: Add apply_to_page_range() which applies a function to a pte range.
Message-ID: <20070316164719.GK10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232528.155002121@goop.org> <20070316091940.GJ23174@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316091940.GJ23174@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Add a new mm function apply_to_page_range() which applies a given 
> > function to every pte in a given virtual address range in a given mm 
> > structure. This is a generic alternative to cut-and-pasting the Linux 
> > idiomatic pagetable walking code in every place that a sequence of 
> > PTEs must be accessed.
> 
> nice one! I suspect we could simplify some of the less 
> performance-critical open-coded pagetable walker loops in the kernel 
> with this? (i'm not even sure it's all that much of a performance loss 
> to pass a function pointer around - would be nice to convert say 
> mprotect() to this and see the performance difference?)

We went through this before, and eventually got kick back to
keep it Xen specific.  There's still some effort for generalized
walkers from the Gelato folks IIRC.  And we can certainly adapt.
