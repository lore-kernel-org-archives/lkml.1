Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYHRD5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYHRD5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 23:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYHRD5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 23:57:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:55416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYHRD5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 23:57:00 -0400
Date: Sun, 17 Aug 2008 20:56:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "airlied@linux.ie" <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 2/2] reduce tlb/cache flush times of agpgart memory
 allocation
Message-ID: <20080817205643.25deb89d@infradead.org>
In-Reply-To: <76780B19A496DC4B80439008DAD7076C0CF9E0E1@PDSMSX501.ccr.corp.intel.com>
References: <1217832690.21811.9.camel@sli10-desk.sh.intel.com>
	<20080815143131.GF12954@elte.hu>
	<20080815074033.4817f876@infradead.org>
	<76780B19A496DC4B80439008DAD7076C0CF9E0E1@PDSMSX501.ccr.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 09:21:12 +0800
"Li, Shaohua" <shaohua.li@intel.com> wrote:

> 
> >
> >it really needs something else instead; it needs airlied's array
> >allocator
> >otherwise you hit the second wall as well (the pat checks per page)
> Somebody should have a measurement. In my test, the real bottleneck
> is the cache flush. It appears flush cache page is slow if there are
> a lot of pages, In my patch, I use a wbinvd. This can be optimized to
> do wbinvd with a threshold. Maybe airlied can change his patch with
> this way.


it would be great if you had time to update his patch and this to
it...

and the logic probably should be "if there's more than X pags in the
the array, just use wbinvd".
Although wbinvd is very painful if you have 12Mb of cache and you wipe
it for all cores in the system ;-(



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
