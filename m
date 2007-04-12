Return-Path: <linux-kernel-owner+w=401wt.eu-S1030628AbXDLSTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbXDLSTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXDLSTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:19:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030628AbXDLSTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:19:19 -0400
Date: Thu, 12 Apr 2007 14:18:09 -0400
From: Dave Jones <davej@redhat.com>
To: Zachary Amsden <zach@vmware.com>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Pte xchg optimization.patch
Message-ID: <20070412181809.GC25646@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Zachary Amsden <zach@vmware.com>, Andrew Morton <akpm@osdl.org>,
	Andi Kleen <ak@muc.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
	David Rientjes <rientjes@google.com>,
	Michel Lespinasse <walken@vmware.com>,
	Virtualization Mailing List <virtualization@lists.osdl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200704120530.l3C5UweV022834@zach-dev.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704120530.l3C5UweV022834@zach-dev.vmware.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 10:30:58PM -0700, Zachary Amsden wrote:
 > In situations where page table updates need only be made locally, and there
 > is no cross-processor A/D bit races involved, we need not use the heavyweight
 > xchg instruction to atomically fetch and clear page table entries.  Instead,
 > we can just read and clear them directly.
 > 
 > This introduces a neat optimization for non-SMP kernels; drop the atomic
 > xchg operations from page table updates.

Would it be feasible to do this using the smp_alternatives stuff?
Given many distros are now shipping SMP-only kernels, it'd be nice
to get that win without using having to rebuild their kernels.

	Dave

-- 
http://www.codemonkey.org.uk
