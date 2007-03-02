Return-Path: <linux-kernel-owner+w=401wt.eu-S1422674AbXCBIjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422674AbXCBIjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 03:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422672AbXCBIjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 03:39:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49267 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422674AbXCBIjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 03:39:47 -0500
Date: Fri, 2 Mar 2007 00:39:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fernando Luis =?ISO-8859-1?B?VuF6cXVleg==?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       judith@linux-foundation.org
Subject: Re: [PATCH 5/5] Move definition of hard_smp_processor_id to
 asm/smp.h - alpha, m32r, powerpc, s390, sparc, sparc64, um
Message-Id: <20070302003935.7282df6a.akpm@linux-foundation.org>
In-Reply-To: <1172824281.6646.3.camel@sebastian.intellilink.co.jp>
References: <1172733503.1498.275.camel@sebastian.intellilink.co.jp>
	<20070301090348.GA8405@osiris.boeblingen.de.ibm.com>
	<1172824281.6646.3.camel@sebastian.intellilink.co.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 17:31:21 +0900 Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:

> On Thu, 2007-03-01 at 10:03 +0100, Heiko Carstens wrote:
> > On Thu, Mar 01, 2007 at 04:18:23PM +0900, Fernando Luis Vázquez Cao wrote:
> > > Move definition of hard_smp_processor_id to asm/smp.h on alpha, m32r,
> > > powerpc, s390, sparc, sparc64, and um architectures.
> > > 
> > > Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > > ---
> > > 
> > > diff -urNp linux-2.6.21-rc2/include/asm-alpha/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-alpha/smp.h
> > > --- linux-2.6.21-rc2/include/asm-alpha/smp.h	2007-02-05 03:44:54.000000000 +0900
> > > +++ linux-2.6.21-rc2-hwcpuid/include/asm-alpha/smp.h	2007-03-07 13:34:14.000000000 +0900
> > > @@ -51,6 +51,7 @@ int smp_call_function_on_cpu(void (*func
> > > 
> > >  #else /* CONFIG_SMP */
> > > 
> > > +#define hard_smp_processor_id()		0
> > >  #define smp_call_function_on_cpu(func,info,retry,wait,cpu)    ({ 0; })
> > > 
> > >  #endif /* CONFIG_SMP */
> > 
> > /me thinks you should merge this patch with patch 1. Otherwise there is no
> > hard_smp_processor_id() defined on any architecture if only patch 1 is
> > applied. That would break a git bisect search.
> Hi Heiko,
> 
> Thank you for reviewing the patch-set. The patches have already been
> merged in Andrew's tree but I will take your advice into account when
> submitting new patches. I certainly would not like to break bisect
> searches.
> 

I swizzled your patches around so the bisect problem should be gone.

At least, the one which Heiko identified - there might be others.
