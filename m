Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbYHRIEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbYHRIEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYHRIE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:04:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35294 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYHRIEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:04:24 -0400
Date: Mon, 18 Aug 2008 10:03:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "airlied@linux.ie" <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 2/2] reduce tlb/cache flush times of agpgart memory
	allocation
Message-ID: <20080818080344.GK30694@elte.hu>
References: <1217832690.21811.9.camel@sli10-desk.sh.intel.com> <20080815143131.GF12954@elte.hu> <20080815074033.4817f876@infradead.org> <76780B19A496DC4B80439008DAD7076C0CF9E0E1@PDSMSX501.ccr.corp.intel.com> <20080817205643.25deb89d@infradead.org> <76780B19A496DC4B80439008DAD7076C0CF9E403@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76780B19A496DC4B80439008DAD7076C0CF9E403@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li, Shaohua <shaohua.li@intel.com> wrote:

> > it would be great if you had time to update his patch and this to 
> > it...
>
> I'll do it soon.

great! Please do it as a delta patch against tip/master:

   http://people.redhat.com/mingo/tip.git/README

as your first two patches are being tested already:

 466ae83: reduce tlb/cache flush times of agpgart memory allocation
 1ac2f7d: introduce two APIs for page attribute

[ but it can all only go upstream once the observations from Arjan have
  been addressed. ]

> > and the logic probably should be "if there's more than X pags in the 
> > the array, just use wbinvd". Although wbinvd is very painful if you 
> > have 12Mb of cache and you wipe it for all cores in the system ;-(
>
> This might not be that bad, changing attribute isn't frequently used.

dont some X/DRM drivers do it for a wide range of GX ops?

	Ingo
