Return-Path: <linux-kernel-owner+w=401wt.eu-S1161275AbXCNN2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161275AbXCNN2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161277AbXCNN2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:28:38 -0400
Received: from kanga.kvack.org ([66.96.29.28]:43416 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161275AbXCNN2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:28:37 -0400
Date: Wed, 14 Mar 2007 09:28:20 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 28/34] Xen-pv_ops: Xen SMP guest support
Message-ID: <20070314132820.GL6209@kvack.org>
References: <20070313233017.933601256@goop.org> <20070313233034.586018620@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313233034.586018620@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 04:30:45PM -0700, Jeremy Fitzhardinge wrote:
> [ brcl, mingo: Would you mind having a close look at the code in
>   xen_exit_mm and drop_mm_ref? - Thanks ]

I see what you're doing here, and this comment seems to allude to the reasons 
behind it without spelling it out.

> +/*
> + * We aggressively remove defunct pgd from cr3. We execute unmap_vmas()
> + * *much* faster this way.
> + */

Are you switching mms in order to avoid all of the overhead associated with 
flushing an active mm during task exit?  If so, it makes much more sense to 
do this in the generic helper, as it should be a win on x86 and x86-64 
where switching to init_mm is relatively low cost given the support for 
global pages.  I'll run some tests on a couple of systems this evening and 
post the results.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
