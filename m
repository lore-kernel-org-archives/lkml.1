Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbYJ0R4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbYJ0R4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYJ0R4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:56:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45914 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbYJ0R4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:56:14 -0400
Date: Mon, 27 Oct 2008 18:55:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: keep the page count correct
Message-ID: <20081027175547.GE3046@elte.hu>
References: <490406FD.30604@kernel.org> <20081027165028.GB30573@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027165028.GB30573@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Sat, Oct 25, 2008 at 10:58:21PM -0700, Yinghai Lu wrote:
> > 
> > impact: get correct page count for 2M and 1G...
> > 
> > found page count in /proc/meminfo is nor correct on 1G system in VirtualBox 2.0.4
> > 
> > # cat /proc/meminfo
> > MemTotal:        1017508 kB
> > MemFree:          822700 kB
> > Buffers:            1456 kB
> > Cached:            26632 kB
> > SwapCached:            0 kB
> > ...
> > Hugepagesize:       2048 kB
> > DirectMap4k:      4032 kB
> > DirectMap2M:  18446744073709549568 kB
> > 
> > with this patch get:
> > ...
> > DirectMap4k:      4032 kB
> > DirectMap2M:   1044480 kB
> > 
> > which is consistent to kernel_page_tables
> > ---[ Low Kernel Mapping ]---
> > 0xffff880000000000-0xffff880000001000           4K     RW     PCD     GLB x  pte
> > 0xffff880000001000-0xffff88000009f000         632K     RW             GLB x  pte
> > 0xffff88000009f000-0xffff8800000a0000           4K     RW     PCD     GLB x  pte
> > 0xffff8800000a0000-0xffff880000200000        1408K     RW             GLB x  pte
> > 0xffff880000200000-0xffff88003fe00000        1020M     RW         PSE GLB x  pmd
> > 0xffff88003fe00000-0xffff88003fff0000        1984K     RW             GLB NX pte
> > 0xffff88003fff0000-0xffff880040000000          64K                           pte
> > 0xffff880040000000-0xffff888000000000         511G                           pud
> > 0xffff888000000000-0xffffc20000000000       58880G                           pgd
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

applied to tip/x86/urgent, thanks guys!

	Ingo
