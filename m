Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbZDXNgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbZDXNgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbZDXNgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:36:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZDXNgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:36:15 -0400
Date: Fri, 24 Apr 2009 09:36:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Robert Richter <robert.richter@amd.com>
cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
In-Reply-To: <20090424100943.GJ27264@erda.amd.com>
Message-ID: <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com> <1240553210.6842.871.camel@yhuang-dev.sh.intel.com> <20090424100943.GJ27264@erda.amd.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Apr 2009, Robert Richter wrote:

> On 24.04.09 14:06:50, Huang Ying wrote:
> > On Wed, 2009-04-22 at 18:16 +0800, Robert Richter wrote:
> > > On 22.04.09 11:22:59, Ingo Molnar wrote:
> > > > 
> > > > * Huang Ying <ying.huang@intel.com> wrote:
> > > > 
> > > > > Re-implement MCE log ring buffer as per-CPU ring buffer for better 
> > > > > scalability. Basic design is as follow:
> > > > 
> > > > Before changing anything substantial in the MCE code it would be 
> > > > necessary to clean up and then unify the 32-bit and 64-bit side of 
> > > > the MCE code first. (Which essentially means extending the 
> > > > 64-bit-only code to 32-bit)
> > > 
> > > You may also want to consider to use the in-kernel ring_buffer api
> > > (include/linux/ring_buffer.h).
> > 
> > It seems that ring_buffer is not NMI-safe, while mcelog buffer will be
> > used in NMI context and interrupt context. When will ring_buffer to be
> > NMI-safe?
> 
> You can use it in nmi context with separate read and write
> buffers. See this patch description:
> 6dad828b76c7224a22ddc9ce7aa495d994f03b31
> 
> Not sure if somebody will make the ring_buffer non-locking.

It already is ;-)

I've put in for a patent application on the algorithm so I must wait till 
it is processed before I can release the code.

-- Steve

