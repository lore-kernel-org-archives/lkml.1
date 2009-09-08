Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbZIHThy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbZIHThy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZIHThy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZIHThx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:37:53 -0400
Date: Tue, 8 Sep 2009 16:37:52 -0300
From: Glauber Costa <glommer@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH v2 1/2] keep guest wallclock in sync with host clock
Message-ID: <20090908193752.GH9013@mothafucka.localdomain>
References: <1251902098-8660-1-git-send-email-glommer@redhat.com> <1251902098-8660-2-git-send-email-glommer@redhat.com> <20090908184159.GC19318@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908184159.GC19318@amt.cnet>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 03:41:59PM -0300, Marcelo Tosatti wrote:
> On Wed, Sep 02, 2009 at 10:34:57AM -0400, Glauber Costa wrote:
> > KVM clock is great to avoid drifting in guest VMs running ontop of kvm.
> > However, the current mechanism will not propagate changes in wallclock value
> > upwards. This effectively means that in a large pool of VMs that need accurate timing,
> > all of them has to run NTP, instead of just the host doing it.
> > 
> > Since the host updates information in the shared memory area upon msr writes,
> > this patch introduces a worker that writes to that msr, and calls do_settimeofday
> > at fixed intervals, with second resolution. A interval of 0 determines that we
> > are not interested in this behaviour. A later patch will make this optional at
> > runtime
> > 
> > Signed-off-by: Glauber Costa <glommer@redhat.com>
> 
> As mentioned before, ntp already does this (and its not that heavy is
> it?).
> 
> For example, if ntp running on the host, it avoids stepping the clock
> backwards by slow adjustment, while the periodic frequency adjustment on
> the guest bypasses that.

Simple question: How do I run ntp in guests without network?

