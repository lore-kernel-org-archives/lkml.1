Return-Path: <linux-kernel-owner+w=401wt.eu-S1161328AbXCNPFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161328AbXCNPFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161329AbXCNPFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:05:30 -0400
Received: from gw.goop.org ([64.81.55.164]:45571 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161328AbXCNPF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:05:29 -0400
Message-ID: <45F80F38.2080707@goop.org>
Date: Wed, 14 Mar 2007 08:05:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 28/34] Xen-pv_ops: Xen SMP guest support
References: <20070313233017.933601256@goop.org> <20070313233034.586018620@goop.org> <20070314132820.GL6209@kvack.org>
In-Reply-To: <20070314132820.GL6209@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise wrote:
> Are you switching mms in order to avoid all of the overhead associated with 
> flushing an active mm during task exit?  If so, it makes much more sense to 
> do this in the generic helper, as it should be a win on x86 and x86-64 
> where switching to init_mm is relatively low cost given the support for 
> global pages.  I'll run some tests on a couple of systems this evening and 
> post the results.

Under Xen, the pagetables are mapped read-only to the guest, so all
pagetable updates need to go via the hypervisor.  If we switch to
init_mm and unpin (make all the pages RW) before pulling the pagetable
apart, then we can just traverse and modify the pagetable memory as
normal RW memory.  It avoids a heap of traps into the hypervisor.

    J

