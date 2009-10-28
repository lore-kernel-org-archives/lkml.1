Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZJ1VIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZJ1VIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZJ1VIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:08:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:12953 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbZJ1VIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:08:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,641,1249282800"; 
   d="scan'208";a="741600841"
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256760953.26028.1770.camel@gandalf.stny.rr.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
	 <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
	 <1256668438.26028.414.camel@gandalf.stny.rr.com>
	 <1256682364.2691.33.camel@sbs-t61.sc.intel.com>
	 <1256679318.26028.468.camel@gandalf.stny.rr.com>
	 <1256685826.15873.41.camel@sbs-t61.sc.intel.com>
	 <1256686285.26028.487.camel@gandalf.stny.rr.com>
	 <1256759778.2683.185.camel@sbs-t61.sc.intel.com>
	 <1256760953.26028.1770.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 28 Oct 2009 14:07:17 -0800
Message-Id: <1256767637.2683.410.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 13:15 -0700, Steven Rostedt wrote:
> On Wed, 2009-10-28 at 11:56 -0800, Suresh Siddha wrote:
> > CPA_DEBUG is setting/clearing unused bit 9. It has no interaction with
> > RW bits. Though the random page and random length selections may end up
> 
> Actually it does. When you call the clear_page_attribute, and go to set
> or clear bit 9, the static_protections() function is called against the
> new_prot. This will clear the RW bit if it is set, even if the original
> caller did not touch that bit.

True. It can happen if the debug test or someone does cpa() before we
mark the text as RO.

> > For CONFIG_DEBUG_RODATA, during the boot we change it to RO.
> 
> We do that at the end of boot up. I'm sure there's a reason for this :-/

Well, alternate_instructions() is one :(. I am convinced that I should
add a check of kernel_set_to_readonly, and if set, I should prevent the
write attribute for the whole large page mapping kernel text, so that we
don't end up breaking it to small pages..

> Yes, because the code clears the RW bit whenever something changes any
> attribute of that page table. Including bit 9.

Yep, noticed it after your earlier comments.

Will send another patch to fix this too. You are ok with the ftrace
change right? I will send both of these shortly.

thanks,
suresh

