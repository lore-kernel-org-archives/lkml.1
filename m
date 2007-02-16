Return-Path: <linux-kernel-owner+w=401wt.eu-S1946104AbXBPV7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946104AbXBPV7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946153AbXBPV7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:59:46 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50074 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946104AbXBPV7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:59:45 -0500
Date: Fri, 16 Feb 2007 13:59:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Zachary Amsden <zach@vmware.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for
 paravirt_ops interface
In-Reply-To: <45D626BB.20007@vmware.com>
Message-ID: <Pine.LNX.4.64.0702161356380.29218@schroedinger.engr.sgi.com>
References: <20070216022449.739760547@goop.org>
 <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com>
 <45D61C74.2000601@vmware.com> <Pine.LNX.4.64.0702161312460.28871@schroedinger.engr.sgi.com>
 <45D626BB.20007@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Zachary Amsden wrote:

> Yes, but that is just because the Xen hooks happens to be near the last part
> of the merge.  VMI required some special hooks, as do both Xen and lhype (I
> think ... Rusty can correct me if lhype's puppy's have precluded the addition
> of new hooks).  Xen page table handling is very different, mostly it is trap
> and emulate so writable page tables can work, which means they don't always
> issue hypercalls for PTE updates, although they do have that option, should
> the hypervisor MMU model change, or performance concerns prompt a different
> model (or perhaps, migration?)

Well looks like there are still some major design issues to be ironed out. 
What is proposed here is to make paravirt_ops a fake generic 
API and then tunnel through it to vendor specific kernel mods.

