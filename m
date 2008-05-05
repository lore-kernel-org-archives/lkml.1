Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYEEC0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYEEC0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 22:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYEECZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 22:25:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34555 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757094AbYEECZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 22:25:51 -0400
Date: Sun, 4 May 2008 21:25:46 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
Message-ID: <20080505022546.GE18857@sgi.com>
References: <patchbomb.1209740703@duo.random> <1489529e7b53d3f2dab8.1209740704@duo.random> <20080504191345.GD18857@sgi.com> <20080504220824.GA21051@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504220824.GA21051@duo.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 12:08:25AM +0200, Andrea Arcangeli wrote:
> On Sun, May 04, 2008 at 02:13:45PM -0500, Robin Holt wrote:
> > > diff --git a/mm/Kconfig b/mm/Kconfig
> > > --- a/mm/Kconfig
> > > +++ b/mm/Kconfig
> > > @@ -205,3 +205,6 @@ config VIRT_TO_BUS
> > >  config VIRT_TO_BUS
> > >  	def_bool y
> > >  	depends on !ARCH_NO_VIRT_TO_BUS
> > > +
> > > +config MMU_NOTIFIER
> > > +	bool
> > 
> > Without some text following the bool keyword, I am not even asked for
> > this config setting on my ia64 build.
> 
> Yes, this was explicitly asked by Andrew after his review. This is the
> explanation pasted from the changelog.
> 
> 3) It'd be a waste to add branches in the VM if nobody could possibly
>    run KVM/GRU/XPMEM on the kernel, so mmu notifiers will only enabled
>    if CONFIG_KVM=m/y. In the current kernel kvm won't yet take
>    advantage of mmu notifiers, but this already allows to compile a
>    KVM external module against a kernel with mmu notifiers enabled and
>    from the next pull from kvm.git we'll start using them. And
>    GRU/XPMEM will also be able to continue the development by enabling
>    KVM=m in their config, until they submit all GRU/XPMEM GPLv2 code
>    to the mainline kernel. Then they can also enable MMU_NOTIFIERS in
>    the same way KVM does it (even if KVM=n). This guarantees nobody
>    selects MMU_NOTIFIER=y if KVM and GRU and XPMEM are all =n.

Ah, so Andrew wants users of KVM to do a select of MMU_NOTIFIER.  That
makes sense.  I will change (fix) my Kconfig changes.

Thanks,
Robin
