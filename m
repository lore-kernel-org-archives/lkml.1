Return-Path: <linux-kernel-owner+w=401wt.eu-S1763865AbYHDWqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763865AbYHDWqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHDWqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:46:01 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37730 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYHDWqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:46:00 -0400
Date: Mon, 4 Aug 2008 15:45:33 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Message-ID: <20080804224533.GC30096@us.ibm.com>
References: <20080804194646.GA17390@us.ibm.com> <57C9024A16AD2D4C97DC78E552063EA308328FB4@orsmsx505.amr.corp.intel.com> <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.2008 [15:00:47 -0700], Luck, Tony wrote:
> > I'd bet resonable sums of money that we are (once again) accessing
> > per-cpu variables in code before ia64 has a chance to initialize
> > things so that they can actually work. :-(
> 
> I tried this simple hack to check ... per-cpu variables are
> not usable until cpu_init() sets up the "ar.k3" register on
> ia64.  So this hack checks to see if it is set before calling
> cpu_clock():

Would you like me to test this patch on the box, to verify? It seems
like you were able to reproduce the non-booting kernel?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
