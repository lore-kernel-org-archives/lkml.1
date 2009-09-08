Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbZIHUPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbZIHUPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZIHUPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:15:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZIHUPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:15:13 -0400
Date: Tue, 8 Sep 2009 17:15:12 -0300
From: Glauber Costa <glommer@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH v2 1/2] keep guest wallclock in sync with host clock
Message-ID: <20090908201512.GI9013@mothafucka.localdomain>
References: <1251902098-8660-1-git-send-email-glommer@redhat.com> <1251902098-8660-2-git-send-email-glommer@redhat.com> <20090908184159.GC19318@amt.cnet> <20090908193752.GH9013@mothafucka.localdomain> <20090908200004.GA20785@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908200004.GA20785@amt.cnet>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 05:00:04PM -0300, Marcelo Tosatti wrote:
> On Tue, Sep 08, 2009 at 04:37:52PM -0300, Glauber Costa wrote:
> > On Tue, Sep 08, 2009 at 03:41:59PM -0300, Marcelo Tosatti wrote:
> > > On Wed, Sep 02, 2009 at 10:34:57AM -0400, Glauber Costa wrote:
> > > > KVM clock is great to avoid drifting in guest VMs running ontop of kvm.
> > > > However, the current mechanism will not propagate changes in wallclock value
> > > > upwards. This effectively means that in a large pool of VMs that need accurate timing,
> > > > all of them has to run NTP, instead of just the host doing it.
> > > > 
> > > > Since the host updates information in the shared memory area upon msr writes,
> > > > this patch introduces a worker that writes to that msr, and calls do_settimeofday
> > > > at fixed intervals, with second resolution. A interval of 0 determines that we
> > > > are not interested in this behaviour. A later patch will make this optional at
> > > > runtime
> > > > 
> > > > Signed-off-by: Glauber Costa <glommer@redhat.com>
> > > 
> > > As mentioned before, ntp already does this (and its not that heavy is
> > > it?).
> > > 
> > > For example, if ntp running on the host, it avoids stepping the clock
> > > backwards by slow adjustment, while the periodic frequency adjustment on
> > > the guest bypasses that.
> > 
> > Simple question: How do I run ntp in guests without network?
> 
> You don't.
For those guests, the mechanism I am proposing comes handy.

Furthermore, it is not only optional, but disabled by default. And then even if you
have a network, but a genuine reason not to use ntp in your VMs, you can use it too.

