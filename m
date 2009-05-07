Return-Path: <linux-kernel-owner+w=401wt.eu-S1762492AbZEGRyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762492AbZEGRyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZEGRyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:54:43 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51909 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbZEGRym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:54:42 -0400
Date: Thu, 7 May 2009 10:54:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507175441.GD6693@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> <1241716718.6311.1531.camel@laptop> <alpine.DEB.1.10.0905071320010.22107@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905071320010.22107@qirst.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 01:20:29PM -0400, Christoph Lameter wrote:
> On Thu, 7 May 2009, Peter Zijlstra wrote:
> 
> > Another user is RCU, the grace period is tick driven, growing these
> > ticks by a factor 50 or so might require some tinkering with forced
> > grace periods when we notice our batch queues getting too long.
> 
> One could also schedule RCU via hrtimers with a large fuzz period?

You could, but then you would still have a periodic interrupt introducing
jitter into your HPC workload.  The approach I suggested allows RCU to be
happy with no periodic interrupts on any CPU that has only one runnable
task that is a CPU-bound user-level task (in addition to the idle task,
of course).

							Thanx, Paul
