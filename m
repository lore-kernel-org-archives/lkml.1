Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZB1JpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZB1JpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZB1Jo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:44:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50297 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZB1Joz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:44:55 -0500
Date: Sat, 28 Feb 2009 10:44:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090228094430.GH12095@elte.hu>
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227001757.GE27240@localdomain>
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


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Thu, Feb 26, 2009 at 12:44:57PM +0100, Ingo Molnar wrote:
> >
> >* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> >
> >> On Wed, Feb 25, 2009 at 09:20:50PM -0800, Yinghai Lu wrote:
> >> >
> >> >Impact: cleanup
> >> >
> >> >that is only needed when CONFIG_X86_VSMP is defined with 64bit
> >> >also remove dead code about PCI, because CONFIG_X86_VSMP depends on PCI
> >> >
> >> >Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> >
> >> 
> >> NAK!
> >> vsmp64.c is compiled unconditionally for a reason.  There are ifdefs in the
> >> file to avoid code compilation based on config options. is_vsmp_box() is
> >> needed even when CONFIG_X86_VSMP is not enabled, since distro kernels don't ship
> >> with CONFIG_X86_VSMP, and since is_vsmp_box() is used to determine  whether
> >> tsc's can be considered synced or not, this is needed.
> >
> >is_vsmp_box() is always available:
> 
> Yes.  But it does not really detect if the machine is vsmp.  
> It is just a 'return 0'.
> 
> >
> >> >+#ifdef CONFIG_X86_VSMP
> >> > extern int is_vsmp_box(void);
> >> >+#else
> >> >+static inline int is_vsmp_box(void)
> >> >+{
> >> >+	return 0;
> >> >+}
> >> >+#endif
> >
> >What this patch does is it reduces the kernel's size when 
> >CONFIG_X86_VSMP is turned off and also makes the code arguably 
> >cleaner.
> 
> True, but by how much? 212 bytes, out of 7285943 bytes which 
> is very very small percentage wise.

How does this eliminate the validity of the patch?

	Ingo
