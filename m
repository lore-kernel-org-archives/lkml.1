Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbZE0JuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbZE0JuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbZE0JuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:50:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46189 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756839AbZE0JuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:50:08 -0400
Date: Wed, 27 May 2009 04:50:06 -0500
From: Robin Holt <holt@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v3] zone_reclaim is always 0 by default
Message-ID: <20090527095006.GE29447@sgi.com>
References: <20090524214554.084F.A69D9226@jp.fujitsu.com> <20090525114135.GD29447@sgi.com> <20090527164549.68B4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527164549.68B4.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 05:06:18PM +0900, KOSAKI Motohiro wrote:
> your last patch is one of considerable thing. but it has one weakness.
> in general "ifdef x86" is wrong idea. almost minor architecture don't
> have sufficient tester. the difference against x86 often makes bug.
> Then, unnecessary difference is hated by much people.

Let me start by saying I can barely understand this entire email.
I appreciate that english is a second language for you and you are
doing a service to the linux community with your contributions despite
the language barrier.  I commend you for your efforts.  I do ask that if
there was more information contained in your email than I am replying too,
please reword it so I may understand.

IIRC, my last patch made it an arch header option to set zone_reclaim_mode
to any value it desired while leaving the default as 1.  The only arch
that changed the default was x86 (both 32 and 64 bit).  That seems the
least disruptive to existing users.

> So, I think we have two selectable choice.
> 
> 1. remove zone_reclaim default setting completely (this patch)
> 2. Only PowerPC and IA64 have default zone_reclaim_mode settings,
>    other architecture always use zone_reclaim_mode=0.

Looks like 2 is the inverse of my patch.  That is fine as well.  The only
reason I formed the patch with the default of 1 and override on x86 is
it was one less line of change and one less file.

Thanks,
Robin
