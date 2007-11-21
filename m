Return-Path: <linux-kernel-owner+w=401wt.eu-S1763333AbXKUAcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763333AbXKUAcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXKUAcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:32:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbXKUAcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:32:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Zachary Amsden <zach@vmware.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] x86 vDSO: consolidate vdso32
In-Reply-To: Zachary Amsden's message of  Tuesday, 20 November 2007 16:13:30 -0800 <1195604010.6352.237.camel@bodhitayantram.eng.vmware.com>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	<20071119220644.F41CA26F8C1@magilla.localdomain>
	<1195604010.6352.237.camel@bodhitayantram.eng.vmware.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071121003209.6B5BD26F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 16:32:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For 64-bit, the hack consists of a switch that chooses whether to use a
fixed address or a generically-assigned one, that's all there is to it.
So it costs about nothing.

Even for 32-bit, CONFIG_COMPAT_VDSO for a while now is doing nothing but
changing the default of the sysctl variable.  There the fixmap part is some
extra stuff that could go away in the ideal in the fullness of time.  But
it doesn't hurt to keep it, especially when never turned on.

The upshot of my changes is that whatever the choices available for the
layout of 32-bit address spaces, they should match on 32-bit and 64-bit kernels.
If you want to reduce that set of choices in both, that is a separate issue.


Thanks,
Roland
