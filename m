Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0CDEFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:05:24 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49949 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab0CDEFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:05:19 -0500
Subject: Re: Nick's vfs-scalability patches ported to 2.6.33-rt
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>,
       John Kacur <jkacur@redhat.com>
In-Reply-To: <20100304033312.GO8653@laptop>
References: <1267163608.2002.9.camel@work-vm> <20100226060109.GH9738@laptop>
	 <1267659090.4317.67.camel@localhost.localdomain>
	 <20100304033312.GO8653@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 20:05:11 -0800
Message-ID: <1267675511.4317.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 14:33 +1100, Nick Piggin wrote:
> On Wed, Mar 03, 2010 at 03:31:30PM -0800, john stultz wrote:
> > On Fri, 2010-02-26 at 17:01 +1100, Nick Piggin wrote:
> > > On Thu, Feb 25, 2010 at 09:53:28PM -0800, john stultz wrote:
> > > > Hey Thomas, Nick,
> > > > 	I just wanted to let you know I've just finished forward porting Nick's
> > > > patches to 2.6.33-rc8-rt2.  Luckily my forward port of Nick's patches to
> > > > 2.6.33 applies on top of the -rt tree without any collisions, and I've
> > > > added a handful of maybe sketchy fixups to get it working with -rt.
> > > > 
> > > > You can find the patchset here:
> > > > http://sr71.net/~jstultz/dbench-scalability/patches/2.6.33-rc8-rt2/vfs-scale.33-rt.tar.bz2
> > > > 
> > > > Here's a chart showing how much these patches help dbench numbers on
> > > > ramfs:
> > > > http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/ramfs-dbench.png
> > > > 
> > > > I've not done any serious stress testing with the patchset yet, but
> > > > wanted to post it for your review.
> > > > 
> > > > Nick: I'd appreciate any feedback as to if any of my forward porting has
> > > > gone awry. I'm still very green with respect to the vfs, so I don't
> > > > doubt there are some issues hiding here.
> > > 
> > > BTW there are a few issues Al pointed out. We have to synchronize RCU
> > > after unregistering a filesystem so d_ops/i_ops doesn't go away, and
> > > mntput can sleep so we can't do it under RCU read lock.
> > 
> > Does the following address this issue properly?
> 
> As far as I could tell, yes that should solve the code reference
> problem. I don't see a problem with synchronizing RCU here.

Good to hear! Thanks for the review Nick!


Thomas:  I ran a number of kernel-bench and dbench stress tests on this
today and I've not seen any issues, so unless Nick has other issues, I
think it should be ok to pull into -rt.

You can grab the full patchset that builds ontop of 2.6.33-rt4 here:
http://sr71.net/~jstultz/dbench-scalability/patches/2.6.33-rt4/vfs-scale.33-rt.tar.bz2

thanks
-john


