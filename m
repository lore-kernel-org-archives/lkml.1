Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbZEGTGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbZEGTGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZEGTGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:06:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50895 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbZEGTGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:06:36 -0400
Date: Thu, 7 May 2009 12:06:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507190632.GG6693@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> <1241716718.6311.1531.camel@laptop> <20090507173608.GC6693@linux.vnet.ibm.com> <1241717904.6311.1558.camel@laptop> <20090507180112.GE6693@linux.vnet.ibm.com> <alpine.DEB.1.10.0905071404390.22107@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905071404390.22107@qirst.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 02:12:15PM -0400, Christoph Lameter wrote:
> To get back to the main point: I agree with Alok that the default HZ needs
> to be as low as possible. The remaining justification is the load
> balancing and possible context switching between multiple tasks contenting
> for a processor.
> 
> Is it enough if this occurs 100 times per second?

I am sorry, I got into solution mode too quickly in my earlier posts.

As long as you have enough memory for the callbacks, and as long
as you don't mind things like netfilter changes taking longer, RCU
doesn't much care what value HZ has.

> If so then we should change the default in kernel/Kconfig.hz.

But some workloads and users do care deeply about memory size and
netfilter-change speed, of course.  So perhaps HPC workloads need
a different default HZ value.

						Thanx, Paul
