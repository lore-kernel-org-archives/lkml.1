Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbZDXKKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbZDXKKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZDXKKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:10:00 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:46731 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZDXKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:09:59 -0400
X-BigFish: VPS-34(zz1432R62a3L98dR936eQ1805M1f3ekzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KILO87-02-KON-01
Date: Fri, 24 Apr 2009 12:09:43 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
Message-ID: <20090424100943.GJ27264@erda.amd.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com> <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 24 Apr 2009 10:09:44.0169 (UTC) FILETIME=[CA322D90:01C9C4C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.04.09 14:06:50, Huang Ying wrote:
> On Wed, 2009-04-22 at 18:16 +0800, Robert Richter wrote:
> > On 22.04.09 11:22:59, Ingo Molnar wrote:
> > > 
> > > * Huang Ying <ying.huang@intel.com> wrote:
> > > 
> > > > Re-implement MCE log ring buffer as per-CPU ring buffer for better 
> > > > scalability. Basic design is as follow:
> > > 
> > > Before changing anything substantial in the MCE code it would be 
> > > necessary to clean up and then unify the 32-bit and 64-bit side of 
> > > the MCE code first. (Which essentially means extending the 
> > > 64-bit-only code to 32-bit)
> > 
> > You may also want to consider to use the in-kernel ring_buffer api
> > (include/linux/ring_buffer.h).
> 
> It seems that ring_buffer is not NMI-safe, while mcelog buffer will be
> used in NMI context and interrupt context. When will ring_buffer to be
> NMI-safe?

You can use it in nmi context with separate read and write
buffers. See this patch description:
6dad828b76c7224a22ddc9ce7aa495d994f03b31

Not sure if somebody will make the ring_buffer non-locking.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

