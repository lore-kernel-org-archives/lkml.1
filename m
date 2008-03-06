Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbYCFPwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbYCFPwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYCFPwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:52:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758910AbYCFPwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:52:03 -0500
Date: Thu, 6 Mar 2008 16:51:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Hellwig <hch@infradead.org>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080306155141.GA23340@elte.hu>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org> <20080304014306.GC28006@linux-os.sc.intel.com> <20080304103220.GA17621@elte.hu> <20080304175528.GD28006@linux-os.sc.intel.com> <20080305194705.GA4386@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305194705.GA4386@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Pavel Machek <pavel@ucw.cz> wrote:

> > > kmem_cache_alloc() can fail (return NULL) and not handling it is a 
> > > bug.
> > 
> > oops. you are correct. Will send a sigsegv in the failure case then. 
> > Thanks.
> 
> You are introducing possibility of hard to debug error, where previous 
> code just worked... Does not look like good idea to me.

hm, how does it differ from any other allocation failure? We could fail 
to allocate a pagetable page. We could fail to allocate the task_struct 
to begin with.

	Ingo
