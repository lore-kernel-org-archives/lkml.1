Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYLZSd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYLZSd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 13:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYLZSdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:33:47 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:45130 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYLZSdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:33:46 -0500
Date: Fri, 26 Dec 2008 19:35:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org, ralf@linux-mips.org,
       kernel@wantstofly.org, hskinnemoen@atmel.com, cooloney@kernel.org,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       jwboyer@linux.vnet.ibm.com, mporter@kernel.crashing.org,
       grant.likely@secretlab.ca, paulus@samba.org, benh@kernel.crashing.org,
       dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH -tip] Switch arm defconfig files from CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Message-ID: <20081226183512.GA1520@uranus.ravnborg.org>
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081225083611.GA14968@elte.hu> <20081225093301.GB27896@uranus.ravnborg.org> <20081225192332.GI6912@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225192332.GI6912@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 11:23:32AM -0800, Paul E. McKenney wrote:
> On Thu, Dec 25, 2008 at 10:33:01AM +0100, Sam Ravnborg wrote:
> > On Thu, Dec 25, 2008 at 09:36:11AM +0100, Ingo Molnar wrote:
> > > 
> > > below is the fix for another small buglet that hits architectures that do 
> > > not include kernel/Kconfig.preempt.
> > 
> > What is needed to let all architectures include Kconfig.preempt?
> > We should not advertise preemption if not supported,
> > but we could do this by a simple Kconfig symbol:
> > 
> > config HAVE_PREEMPT
> > 	bool
> > 
> > And let all architectures that supports preemption do:
> > 
> > config "ARCH"
> > 	select HAVE_PREEMPT
> > 
> > But maybe there is a simpler solution
> 
> The idea being to make things like PREEMPT then depend on HAVE_PREEMPT?
Yes - exactly.

So an arch can say that is includes support for preemption
using the following Kconfig snippet:

config X86
	select HAVE_PREEMPT

And then in the spot where we have a prompt we do:

config PREEMPT
	bool "Do you want preemption?"
	depends on HAVE_PREEMPT


Thne we will only present this option to the user
for the architectures where it has indicated preemption
support by selecting HAVE_PREEMPT.

It is on purpose that HAVE_PREEMPT is a single boolean
with no prompt or anything so we do not hit
any of the pitfalls of using select.

We use a similar pattern in many places today.

	Sam
