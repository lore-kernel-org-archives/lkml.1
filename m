Return-Path: <linux-kernel-owner+w=401wt.eu-S935540AbXJSSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935540AbXJSSf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbXJSSfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:35:20 -0400
Received: from [12.38.223.190] ([12.38.223.190]:20427 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759584AbXJSSfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:35:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18200.63696.399763.437303@zeus.sw.starentnetworks.com>
Date: Fri, 19 Oct 2007 14:34:56 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] i386: fix TSC clock source calibration error [part 2]
In-Reply-To: <4718F0DE.3050207@ct.jp.nec.com>
References: <18196.53154.100115.92459@zeus.sw.starentnetworks.com>
	<20071018085713.GA11022@elte.hu>
	<18200.59017.358372.378373@zeus.sw.starentnetworks.com>
	<4718F0DE.3050207@ct.jp.nec.com>
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto writes:
> Dave Johnson wrote:
> >  		mach_prepare_counter();
> 
> It's a really rare case, but if SMI interrupt takes CPU here, just after
> prepare and before rdtscll, it makes delta64 shorter than expected one.
> Is it possible? And how about moving rdtscll before mach_prepare_counter()?
> 
> >  		rdtscll(start);

Yep, rare indeed (about 1 instruction). Moving the start read before
the prepare call should solve that one too providing the setup doesn't
take any real measurable time.

-- 
Dave Johnson
Starent Networks

